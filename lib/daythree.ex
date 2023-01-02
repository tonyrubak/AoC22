defmodule Aoc22.DayThree do
  def read_data do
    {:ok, content} = File.read("data/day3.txt")
    content
  end

  def parse_data(data) do
    data
    |> String.splitter("\n")
  end

  def find_duplicate(str) do
    len = String.length(str)
    first =
      str
      |> String.slice(0..div(len,2)-1)
      |> String.to_charlist()
      |> MapSet.new()
    rest =
      str
      |> String.slice(div(len,2)..len-1)
      |> String.to_charlist()
      |> MapSet.new()
    MapSet.intersection(first,rest)
      |> MapSet.to_list()
      |> decode
  end

  # def decode([]), do: 0

  def decode([c|_]) when c >= 0x61 do
    c - 0x60
  end

  def decode([c|_]) when c < 0x61 do
    c - 0x41 + 27
  end

  def run() do
    read_data()
    |> parse_data()
    |> Enum.map(fn it -> find_duplicate it end)
    |> Enum.sum
  end
end
