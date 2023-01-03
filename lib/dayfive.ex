defmodule Aoc22.DayFive do
  def read_data do
    {:ok, content} = File.read("data/day5.txt")
    content
  end

  def process(data) do
    buckets = [[], [], [], [], [], [], [], [], []]
    initial =
      data
      |> String.splitter("\n")
      # The initial state is the first 8 lines
      |> Enum.take(8)
      |> Enum.reverse
      |> Enum.map(&Aoc22.DayFiveParser.parseBoxes/1)
      |> Enum.map(fn it -> Kernel.elem(it,1) end)
      |> Enum.reduce(buckets, &bucket_reducer/2)

    data
    |> String.splitter("\n")
    |> Enum.drop(10)
    |> Enum.map(&Aoc22.DayFiveParser.parseCommands/1)
    |> Enum.map(fn it -> Kernel.elem(it,1) end)
    |> Enum.reduce(initial, &crane_reducer/2)
    |> Enum.map(&hd/1)
  end

  def build_buckets([], [], buckets), do: Enum.reverse buckets
  def build_buckets([:empty | tail], [bucket | buckets], res), do: build_buckets(tail, buckets, [bucket | res])
  def build_buckets([value | tail], [bucket | buckets], res), do: build_buckets(tail, buckets, [[value | bucket] | res])

  def bucket_reducer(row, buckets), do: build_buckets(row, buckets, [])

  def crane_reducer([num, from, to], buckets), do: move2(buckets, num, from, to)

  def move(buckets, 0, _from, _to), do: buckets
  def move(buckets, num, from, to) do
    [item | from_bucket] = Enum.at(buckets, from-1)
    to_bucket = [item | Enum.at(buckets, to-1)]
    new_buckets =
        buckets
        |> List.replace_at(from-1, from_bucket)
        |> List.replace_at(to-1, to_bucket)
    move(new_buckets, num-1, from, to)
  end

  def move2(buckets, num, from, to) do
    from_bucket = Enum.at buckets, from-1
    to_bucket = Enum.at buckets, to-1
    moved_buckets = Enum.take from_bucket, num
    buckets
    |> List.replace_at(from-1, Enum.drop(from_bucket, num))
    |> List.replace_at(to-1, moved_buckets ++ to_bucket)
  end
end

defmodule Aoc22.DayFiveParser do
  import NimbleParsec

  separator = ignore(string(" "))
  box = ignore(string("[")) |> utf8_char([?A..?Z]) |> ignore(string("]"))
  empty = replace(string("   "),:empty)
  maybeBox = choice([box,empty])
  boxes = maybeBox |> concat(separator) |> times(8) |> concat(box) |> eos()
  defparsec(:parseBoxes, boxes)

  command =
    ignore(string("move"))
    |> concat(separator)
    |> integer(min: 1, max: 2)
    |> concat(separator)
    |> ignore(string("from"))
    |> concat(separator)
    |> integer(min: 1, max: 2)
    |> concat(separator)
    |> ignore(string("to"))
    |> concat(separator)
    |> integer(min: 1, max: 2)
  defparsec(:parseCommands, command)
end
