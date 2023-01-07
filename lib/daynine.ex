defmodule Aoc22.DayNine do
  def read_data do
    {:ok, content} = File.read("data/day9.txt")
    content
  end

  def process(data) do
    data
    |> String.splitter("\n")
    |> Enum.map(&Aoc22.DayNineParser.parse/1)
    |> Enum.map(fn it -> elem(it, 1) end)
    |> Enum.map(fn [direction: dir, distance: dis] -> {List.to_string([dir]), dis} end)
    |> Enum.reduce({{0,0},{0,0},MapSet.new([{0,0}])}, &path_reducer/2)
    |> elem(2)
    # |> MapSet.size()
  end

  def path_reducer({_,0},acc), do: acc
  # Same X and Y
  # def path_reducer({"U", dist}, {{hx,hy},{hx,hy},locs}), do: path_reducer({"U", dist - 1},{{hx,hy+1},{hx,hy},MapSet.put(locs,{hx,hy})})
  def path_reducer({"D", dist}, {{hx,hy},{hx,hy},locs}), do: path_reducer({"D", dist - 1},{{hx,hy-1},{hx,hy},MapSet.put(locs,{hx,hy})})
  def path_reducer({"R", dist}, {{hx,hy},{hx,hy},locs}), do: path_reducer({"R", dist - 1},{{hx+1,hy},{hx,hy},MapSet.put(locs,{hx,hy})})
  def path_reducer({"L", dist}, {{hx,hy},{hx,hy},locs}), do: path_reducer({"L", dist - 1},{{hx-1,hy},{hx,hy},MapSet.put(locs,{hx,hy})})
  # Same X
  # def path_reducer({"U", dist}, {{hx,hy},{hx,ty},locs}) when ty > hy, do: path_reducer({"U", dist - 1},{{hx,hy+1},{hx,ty},MapSet.put(locs,{hx,ty})})
  # def path_reducer({"U", dist}, {{hx,hy},{hx,ty},locs}) when ty < hy, do: path_reducer({"U", dist - 1},{{hx,hy+1},{hx,ty+1},MapSet.put(locs,{hx,ty+1})})
  def path_reducer({"D", dist}, {{hx,hy},{hx,ty},locs}) when ty > hy, do: path_reducer({"D", dist - 1},{{hx,hy-1},{hx,ty-1},MapSet.put(locs,{hx,ty-1})})
  def path_reducer({"D", dist}, {{hx,hy},{hx,ty},locs}) when ty < hy, do: path_reducer({"D", dist - 1},{{hx,hy-1},{hx,ty},MapSet.put(locs,{hx,ty})})
  def path_reducer({"R", dist}, {{hx,hy},{hx,ty},locs}), do: path_reducer({"R", dist - 1},{{hx+1,hy},{hx,ty},MapSet.put(locs,{hx,ty})})
  def path_reducer({"L", dist}, {{hx,hy},{hx,ty},locs}), do: path_reducer({"L", dist - 1},{{hx-1,hy},{hx,ty},MapSet.put(locs,{hx,ty})})
  # Same Y
  # def path_reducer({"U", dist}, {{hx,hy},{tx,hy},locs}), do: path_reducer({"U", dist - 1},{{hx,hy+1},{tx,hy},MapSet.put(locs,{tx,hy})})
  def path_reducer({"D", dist}, {{hx,hy},{tx,hy},locs}), do: path_reducer({"D", dist - 1},{{hx,hy-1},{tx,hy},MapSet.put(locs,{tx,hy})})
  def path_reducer({"R", dist}, {{hx,hy},{tx,hy},locs}) when tx > hx, do: path_reducer({"R", dist - 1},{{hx+1,hy},{tx,hy},MapSet.put(locs,{tx,hy})})
  def path_reducer({"R", dist}, {{hx,hy},{tx,hy},locs}) when tx < hx, do: path_reducer({"R", dist - 1},{{hx+1,hy},{tx+1,hy},MapSet.put(locs,{tx+1,hy})})
  def path_reducer({"L", dist}, {{hx,hy},{tx,hy},locs}) when tx > hx, do: path_reducer({"L", dist - 1},{{hx-1,hy},{tx-1,hy},MapSet.put(locs,{tx-1,hy})})
  def path_reducer({"L", dist}, {{hx,hy},{tx,hy},locs}) when tx < hx, do: path_reducer({"L", dist - 1},{{hx-1,hy},{tx,hy},MapSet.put(locs,{tx,hy})})
  # Different X and Y
  def path_reducer({"U", dist}, {{hx,hy},{tx,ty},locs}) do
    cond do
      tx == hx and ty == hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{hx,hy},MapSet.put(locs,{hx,hy})})
      tx == hx and ty > hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{hx,ty},MapSet.put(locs,{hx,ty})})
      tx == hx and ty < hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{hx,ty+1},MapSet.put(locs,{hx,ty+1})})
      ty == hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{tx,hy},MapSet.put(locs,{tx,hy})})
      tx > hx and ty > hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{hx,ty},MapSet.put(locs,{hx,ty})})
      tx > hx and ty < hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{hx-1,ty+1},MapSet.put(locs,{hx-1,ty+1})})
      tx < hx and ty > hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{hx,ty},MapSet.put(locs,{hx,ty})})
      tx < hx and ty < hy -> path_reducer({"U", dist - 1},{{hx,hy+1},{hx+1,ty+1},MapSet.put(locs,{hx+1,ty+1})})
    end
  end
  def path_reducer({"D", dist}, {{hx,hy},{tx,ty},locs}) do
    cond do
      tx > hx and ty > hy -> path_reducer({"D", dist - 1},{{hx,hy-1},{hx-1,ty-1},MapSet.put(locs,{hx-1,ty-1})})
      tx > hx and ty < hy -> path_reducer({"D", dist - 1},{{hx,hy-1},{hx,ty},MapSet.put(locs,{hx,ty})})
      tx < hx and ty > hy -> path_reducer({"D", dist - 1},{{hx,hy-1},{hx+1,ty-1},MapSet.put(locs,{hx+1,ty-1})})
      tx < hx and ty < hy -> path_reducer({"D", dist - 1},{{hx,hy-1},{hx,ty},MapSet.put(locs,{hx,ty})})
    end
  end
  def path_reducer({"R", dist}, {{hx,hy},{tx,ty},locs}) do
    cond do
      tx > hx and ty > hy -> path_reducer({"R", dist - 1},{{hx+1,hy},{hx,ty},MapSet.put(locs,{hx,ty})})
      tx > hx and ty < hy -> path_reducer({"R", dist - 1},{{hx+1,hy},{hx,ty},MapSet.put(locs,{hx,ty})})
      tx < hx and ty > hy -> path_reducer({"R", dist - 1},{{hx+1,hy},{hx+1,ty-1},MapSet.put(locs,{hx+1,ty-1})})
      tx < hx and ty < hy -> path_reducer({"R", dist - 1},{{hx+1,hy},{hx+1,ty+1},MapSet.put(locs,{hx+1,ty+1})})
    end
  end
  def path_reducer({"L", dist}, {{hx,hy},{tx,ty},locs}) do
    cond do
      tx > hx and ty > hy -> path_reducer({"L", dist - 1},{{hx-1,hy},{hx-1,ty-1},MapSet.put(locs,{hx-1,ty-1})})
      tx > hx and ty < hy -> path_reducer({"L", dist - 1},{{hx-1,hy},{hx-1,ty+1},MapSet.put(locs,{hx-1,ty+1})})
      tx < hx and ty > hy -> path_reducer({"L", dist - 1},{{hx-1,hy},{hx,ty},MapSet.put(locs,{hx,ty})})
      tx < hx and ty < hy -> path_reducer({"L", dist - 1},{{hx-1,hy},{hx,ty},MapSet.put(locs,{hx,ty})})
    end
  end
end

defmodule Aoc22.DayNineParser do
  import NimbleParsec

  direction = utf8_char([?L,?R,?U,?D]) |> unwrap_and_tag(:direction)
  distance = integer(min: 1) |> unwrap_and_tag(:distance)
  line =
    direction
    |> ignore(string(" "))
    |> concat(distance)

  defparsec(:parse, line)
end
