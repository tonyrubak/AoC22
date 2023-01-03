defmodule Aoc22.DayFive do
  # Hardcode this
  @buckets 9

  def read_data do
    {:ok, content} = File.read("data/day5.txt")
    content
  end

  def read_initial_state(data) do
    buckets = [[], [], [], [], [], [], [], [], []]
    initial =
      data
      |> String.splitter("\n")
      # The initial state is the first 8 lines
      |> Enum.take(8)
      |> Enum.reverse
      |> Enum.map(&Aoc22.DayFiveParser.parse/1)
      |> Enum.map(fn it -> Kernel.elem(it,1) end)
      |> Enum.reduce(buckets, &bucket_reducer/2)
    # build_buckets Enum.zip buckets, parsed
  end

  def build_buckets([], [], buckets), do: Enum.reverse buckets
  def build_buckets([:empty | tail], [bucket | buckets], res), do: build_buckets(tail, buckets, [bucket | res])
  def build_buckets([value | tail], [bucket | buckets], res), do: build_buckets(tail, buckets, [[value | bucket] | res])

  def bucket_reducer(row, buckets) do
    row
    |> build_buckets(buckets, [])
  end
end

defmodule Aoc22.DayFiveParser do
  import NimbleParsec

  separator = ignore(string(" "))
  box = ignore(string("[")) |> utf8_char([?A..?Z]) |> ignore(string("]"))
  empty = replace(string("   "),:empty)
  maybeBox = choice([box,empty])
  boxes = maybeBox |> concat(separator) |> times(8) |> concat(box) |> eos()
  defparsec(:parse, boxes)
end
