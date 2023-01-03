defmodule Aoc22.DayFour do
  def read_data do
    {:ok, content} = File.read("data/day4.txt")
    content
  end

  def process_data(data,processor) do
    data
    |> String.splitter("\n")
    |> Enum.map(fn x -> process_line(x,processor) end)
    |> Enum.sum
  end

  def process_line(line,processor) do
    line
    |> String.splitter(",")
    |> Enum.map(&parse_range/1)
    |> processor.()
    |> count_true
  end

  def process_line_proper(line) do
    line
    |> String.splitter(",")
    |> Enum.map(&parse_range/1)
    |> proper_subset()
    |> count_true
  end

  def process_line_subset(line) do
    line
    |> String.splitter(",")
    |> Enum.map(&parse_range/1)
    |> subset()
    |> count_true
  end

  def parse_range(item) do
    [low | [high | []]] = item
    |> String.splitter("-")
    |> Enum.map(&String.to_integer/1)
    low..high
  end

  def count_true(b) when b, do: 1
  def count_true(b) when not b, do: 0

  # Require that r1l <= r2l
  def proper_subset(r1l..r1h,r2l..r2h) when r1l > r2l, do: proper_subset(r2l..r2h,r1l..r1h)
  def proper_subset(r1l..r1h,r2l..r2h) when r1l == r2l or r1h == r2h, do: true
  def proper_subset(r1l..r1h,r2l..r2h) when r1l < r2l and r1h > r2h, do: true
  def proper_subset(_r1,_r2), do: false
  def proper_subset([r1 | [r2 | []]]), do: proper_subset(r1,r2)

  def subset([r1 | [r2 | []]]), do: subset(r1,r2)
  def subset((r1l..r1h) = r1,(r2l..r2h) = r2) do
    proper_subset(r1,r2) or (r1l in r2 or r1h in r2) or (r2l in r1 or r2h in r1)
  end
end
