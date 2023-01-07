defmodule Aoc22.DayNine do
  def read_data do
    {:ok, content} = File.read("data/day9.txt")
    content
  end

  def process(data) do
    path = data
    |> String.splitter("\n")
    |> Enum.map(&Aoc22.DayNineParser.parse/1)
    |> Enum.map(fn it -> elem(it, 1) end)
    |> Enum.map(fn [direction: dir, distance: dis] -> {List.to_string([dir]), dis} end)
    |> Enum.reduce([{0,0}],&generate_path/2) # H
    |> Enum.reverse
    path = for _ <- 1..9, reduce: path do
      acc ->
        acc
        |> Enum.reduce({{0,0},[{0,0}]},&follow/2)
        |> elem(1)
        |> Enum.reverse
    end
    path
    |> MapSet.new()
    |> MapSet.size()
  end

  def distance({hx,hy},{tx,ty}), do: :math.sqrt(:math.pow(hx-tx,2) + :math.pow(hy-ty,2))

  @sqrt2 :math.sqrt(2)

  def generate_path({_,0}, path), do: path
  def generate_path({"U",dist},[{x,y}|_tl]=path), do: generate_path({"U",dist-1},[{x,y+1}|path])
  def generate_path({"D",dist},[{x,y}|_tl]=path), do: generate_path({"D",dist-1},[{x,y-1}|path])
  def generate_path({"R",dist},[{x,y}|_tl]=path), do: generate_path({"R",dist-1},[{x+1,y}|path])
  def generate_path({"L",dist},[{x,y}|_tl]=path), do: generate_path({"L",dist-1},[{x-1,y}|path])

  def follow({hx,hy}=head,{{tx,ty}=tail,res}) do
    dist = distance(head,tail)
    dx = (hx - tx)
    dy = (hy - ty)
    dx = if dx == 0 do
      dx
    else
      div(dx,abs(dx))
    end
    dy = if dy == 0 do
      dy
    else
      div(dy,abs(dy))
    end
    new_tail = cond do
      dist <= @sqrt2 -> tail
      dist > @sqrt2 -> {tx+dx,ty+dy}
    end
    {new_tail, [new_tail | res]}
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
