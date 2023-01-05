defmodule Aoc22.DaySeven do
  def read_data do
    {:ok, content} = File.read("data/day7.txt")
    content
  end

  def process(data) do
    {_, paths, tree} =
      data
      |> String.splitter("\n")
      |> Enum.map(&Aoc22.DaySevenParser.parse/1)
      |> Enum.map(fn it -> elem(it,1) end)
      |> Enum.to_list()
      |> Enum.reduce({["/"],[["/"]],%{"/" => %{}}},&reducer/2)
    paths
    |> Enum.map(fn path -> dir_size(tree, Enum.reverse(path)) end)
    |> Enum.filter(fn item -> item < 100000 end)
    |> Enum.sum()

    free_space = 70000000 - dir_size(tree,["/"])
    needed = 30000000 - free_space
    paths
    |> Enum.map(fn path -> dir_size(tree, Enum.reverse(path)) end)
    |> Enum.filter(fn item -> item >= needed end)
    |> Enum.min()
  end

  def reducer([cd: "/"],{_path,paths,res}), do: {["/"],paths,res}
  def reducer([cd: ".."],{path,paths,res}), do: {tl(path),paths,res}
  def reducer([cd: up],{path,paths,res}), do: {[up|path],paths,res}
  def reducer([directory: dir], {path,paths,res}), do: {path, [[dir|path] | paths], tree_insert(res, Enum.reverse(path),[directory: dir])}
  def reducer([ls: _],acc), do: acc
  def reducer([file: file],{path,paths,res}), do: {path, paths, tree_insert(res, Enum.reverse(path), [file: file])}
  def reducer(_,acc), do: acc

  # Given a tree, a path, and a directory or file inserts that file or directory
  # into the correct spot on the tree
  # Path must be in root-first order
  def tree_insert(tree, [h|t], [directory: dir]), do: Map.put(tree,h,tree_insert(tree[h], t, [directory: dir]))
  def tree_insert(tree, [], [directory: dir]), do: Map.put(tree,dir,%{})
  def tree_insert(tree, [h|t], [file: f]), do: Map.put(tree,h,tree_insert(tree[h], t, [file: f]))
  def tree_insert(tree, [], [file: [size: s, file_name: n]]), do: Map.put(tree,n,%{:size => s})

  # Given a tree and a path determines the total size of the directory at that path
  # Path must be in root-first order
  def dir_size(%{size: size},[]), do: size
  def dir_size(dir, [h|t]), do: dir_size(dir[h], t)
  def dir_size(dir, []), do: Enum.sum(Enum.map(dir, fn {_k,v} -> dir_size(v,[]) end))
end

defmodule Aoc22.DaySevenParser do
  import NimbleParsec

  cd =
    ignore(string("$ cd "))
    |> utf8_string([], min: 1)
    |> unwrap_and_tag(:cd)

  ls =
    ignore(string("$ ls"))
    |> tag(:ls)

  dir =
    ignore(string("dir "))
    |> utf8_string([], min: 1)
    |> unwrap_and_tag(:directory)

  filesize =
    integer(min: 1)
    |> unwrap_and_tag(:size)

  filename =
    utf8_string([], min: 1)
    |> unwrap_and_tag(:file_name)

  file =
    filesize
    |> concat(ignore(string(" ")))
    |> concat(filename)
    |> tag(:file)

  defparsec(:parse, choice([cd, ls, dir, file]))
end
