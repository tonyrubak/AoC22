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

  def find_badge(bags), do: find_badge(bags, 0)

  def find_badge([], total), do: total

  def find_badge([a | [b | [c | tl]]], total) do
    badge = [a,b,c]
    |> Enum.map(fn x -> String.to_charlist(x) end)
    |> Enum.map(fn x -> MapSet.new(x) end)
    |> intersect3()
    |> MapSet.to_list()
    |> decode
    find_badge(tl, total + badge)
  end

  def intersect3([a,b,c]) do
    a
    |> MapSet.intersection(b)
    |> MapSet.intersection(c)
  end

  def run() do
    read_data()
    |> parse_data()
    |> Enum.map(fn it -> find_duplicate it end)
    |> Enum.sum
  end

  def run2() do
    read_data()
    |> parse_data()
    |> Enum.to_list()
    |> find_badge()
  end
end
