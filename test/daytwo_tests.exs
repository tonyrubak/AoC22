defmodule Aoc22DayTwoTest do
  use ExUnit.Case
  doctest Aoc22.DayOne

  test "given a string returns an array of pairs of RPS plays" do
    data = "A Y\nB X\nC Z"
    assert Aoc22.DayTwo.parse_data(data) == [{:rock,:paper},{:paper,:rock},{:scissors,:scissors}]
  end

  test "given a strategy, scores the strategy" do
    data = [{:rock,:paper},{:paper,:rock},{:scissors,:scissors}]
    assert Aoc22.DayTwo.score_strategy(data) == 15
  end
end
