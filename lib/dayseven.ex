defmodule Aoc22.DaySeven do
  def read_data do
    {:ok, content} = File.read("data/day7.txt")
    content
  end

  def process(data) do
    data
    |> String.splitter("\n")
    |> Enum.map(&Aoc22.DaySevenParser.parse/1)
    |> Enum.map(fn it -> elem(it,1) end)
    |> Enum.to_list()
    |> Enum.reduce({["/"],0},&reducer/2)
  end

  def reducer([cd: "/"],{_path,res}), do: {["/"],res}
  def reducer([cd: ".."],{path,res}), do: {tl(path), res}
  def reducer([cd: up],{path,res}), do: {[up|path], res}
  def reducer([ls: _],acc), do: acc
  def reducer(_,acc), do: acc
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
