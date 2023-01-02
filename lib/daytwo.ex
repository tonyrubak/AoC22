defmodule Aoc22.DayTwo do

  def read_data do
    {:ok, content} = File.read("data/day2.txt")
    content
  end

  def parse_data(data) do
    data
    |> String.splitter("\n")
    |> Enum.map(fn x -> parse_line(x) end)
  end

  def parse_line(line) do
    line
    |> String.splitter(" ")
    |> Enum.map(&(parse_symbol(&1)))
    |> List.to_tuple()
  end

  def parse_symbol("A"), do: :rock
  def parse_symbol("B"), do: :paper
  def parse_symbol("C"), do: :scissors
  def parse_symbol("X"), do: :rock
  def parse_symbol("Y"), do: :paper
  def parse_symbol("Z"), do: :scissors

  def score_symbol(:rock), do: 1
  def score_symbol(:paper), do: 2
  def score_symbol(:scissors), do: 3

  def score_outcome({:rock, :rock}), do: 3
  def score_outcome({:rock, :paper}), do: 6
  def score_outcome({:rock, :scissors}), do: 0
  def score_outcome({:paper, :rock}), do: 0
  def score_outcome({:paper, :paper}), do: 3
  def score_outcome({:paper, :scissors}), do: 6
  def score_outcome({:scissors, :rock}), do: 6
  def score_outcome({:scissors, :paper}), do: 0
  def score_outcome({:scissors, :scissors}), do: 3

  def score_round({_opp, self} = round) do
    score_outcome(round) + score_symbol(self)
  end

  def score_strategy(rounds) do
    rounds
    |> Enum.map(&(score_round(&1)))
    |> Enum.sum
  end

  def run() do
    read_data()
    |> parse_data()
    |> score_strategy()
  end
end
