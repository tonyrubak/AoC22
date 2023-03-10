defmodule Aoc22.Graph do
  def push({[], _}, item), do: {[item], []}
  def push({first, last}, item), do: {first, [item | last]}
  def pop({[item | []], last}), do: {item, {Enum.reverse(last), []}}
  def pop({[head | tail], last}), do: {head, {tail, last}}

  def new(nvertex, edges) do
    nodes = Enum.map(0..nvertex, fn i -> new_node(i) end)

    for {u, v} <- edges, reduce: nodes do
      acc ->
        add_neighbor(acc, u, v)
    end
  end

  def bfs(graph, start) do
    d =
      graph
      |> Enum.map(fn _ -> -1 end)

    prev =
      graph
      |> Enum.map(fn _ -> :none end)

    d = List.replace_at(d, start[:index], 0)

    q = {[start], []}
    bfs_worker(graph, q, d, prev)
  end

  def bfs_worker(_graph, {[], []}, d, _), do: d

  def bfs_worker(graph, q, d, prev) do
    {current, q} = pop(q)

    {q, d, prev} =
      for node_ind <- current[:neighbors], reduce: {q, d, prev} do
        {q, d, prev} ->
          node = Enum.at(graph, node_ind)

          if Enum.at(d, node[:index]) == -1 do
            q = push(q, node)
            prev = List.replace_at(prev, node[:index], current[:index])
            d = List.replace_at(d, node[:index], Enum.at(d, current[:index]) + 1)
            {q, d, prev}
          else
            {q, d, prev}
          end
      end

    bfs_worker(graph, q, d, prev)
  end

  defp add_neighbor(graph, u, v),
    do: List.update_at(graph, u, fn node -> %{node | neighbors: [v | node[:neighbors]]} end)

  defp new_node(index) do
    %{index: index, cc: -1, visited: false, neighbors: []}
  end
end

defmodule Aoc22.DayTwelve do
  alias Aoc22.Graph

  def read_data do
    {:ok, content} = File.read("data/day12.txt")
    content
  end

  def process(data) do
    parsed_lines =
      data
      |> String.splitter("\n")
      |> Enum.map(&Aoc22.DayTwelveParser.parse/1)
      |> Enum.map(fn it -> elem(it, 1) end)

    nodes =
      parsed_lines
      |> Enum.zip(1..length(parsed_lines))
      |> Enum.flat_map(fn {line, y} ->
        line
        |> Enum.zip(1..length(line))
        |> Enum.map(fn
          {{:height, height}, x} -> {:height, height, {x, y}}
          {{type, height}, x} -> {type, hd(String.to_charlist(height)), {x, y}}
        end)
      end)

    nodes = Enum.zip(1..length(nodes), nodes)

    neighbors =
      nodes
      |> Enum.flat_map(fn node -> neighbors(node, nodes) end)

    graph = Graph.new(length(nodes), neighbors)

    end_ind =
      nodes
      |> Enum.filter(fn {_ind, node} -> elem(node, 0) == :end end)
      |> hd()
      |> elem(0)

    nodes
    |> Enum.filter(fn {_ind, node} -> elem(node, 1) == 97 end)
    |> Enum.map(fn it -> elem(it, 0) end)
    |> Enum.map(fn start -> Enum.at(graph, start) end)
    |> Enum.map(fn start_node -> Graph.bfs(graph, start_node) end)
    |> Enum.map(fn dists -> Enum.at(dists, end_ind) end)
    |> Enum.filter(fn dist -> dist > 0 end)
    |> Enum.min()
  end

  def neighbors({ind, node}, nodes) do
    nodes = List.delete_at(nodes, ind - 1)
    node_inds = Enum.map(nodes, fn node -> elem(node, 0) end)

    vs =
      nodes
      |> Enum.map(fn other -> is_neighbor(node, other) end)
      |> Enum.zip(node_inds)
      |> Enum.filter(fn {is_n, _} -> is_n end)
      |> Enum.map(fn {_, ind} -> ind end)

    us = Enum.map(1..length(vs), fn _ -> ind end)

    Enum.zip(us, vs)
  end

  def is_neighbor({_, lheight, {lx, ly}}, {_, {_, rheight, {rx, ry}}}) do
    dx = abs(lx - rx)
    dy = abs(ly - ry)
    adjacent = (dx == 0 and dy == 1) or (dx == 1 and dy == 0)

    if adjacent and rheight - 1 <= lheight do
      true
    else
      false
    end
  end
end

defmodule Aoc22.DayTwelveParser do
  import NimbleParsec

  node = utf8_char([?a..?z]) |> unwrap_and_tag(:height)
  start = utf8_char([?S..?S]) |> replace("a") |> unwrap_and_tag(:start)
  end_node = utf8_char([?E..?E]) |> replace("z") |> unwrap_and_tag(:end)

  node_line = choice([node, start, end_node]) |> repeat()
  defparsec(:parse, node_line)
end
