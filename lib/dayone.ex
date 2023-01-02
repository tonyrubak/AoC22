defmodule Aoc22.DayOne do

  def read_data do
    {:ok, content} = File.read("data/day1.txt")
    content
  end

  def parse_data(data) do
    data
    |> String.splitter("\n")
    |> Enum.map(fn x -> parse_line(x) end)
  end

  def parse_line(""), do: :newelf
  def parse_line(line), do: Integer.parse(line) |> elem(0)

  def sum_elves(data), do: sum_elves(data,[],0)
  def sum_elves([:newelf|tl],elves,elf), do: sum_elves(tl, [elf | elves], 0)
  def sum_elves([hd|tl],elves,elf), do: sum_elves(tl, elves, elf + hd)
  def sum_elves([], elves, elf), do: Enum.reverse([elf | elves])

  def solve(data) do
    data
    |> parse_data()
    |> sum_elves()
    |> Enum.max()
  end

  def solve2(data) do
    data
    |> parse_data()
    |> sum_elves()
    |> Enum.sort(&(&1 >= &2))
    |> Enum.take(3)
    |> Enum.sum
  end

  def run do
    read_data() |> solve
  end

  def run2 do
    read_data() |> solve2
  end
end
