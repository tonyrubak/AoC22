defmodule Aoc22DayThreeTest do
  use ExUnit.Case

  test "given a string returns the item that appears in both halves" do
    data = "vJrwpWtwJgWrhcsFMMfFFhFp"
    assert Aoc22.DayThree.find_duplicate(data) == 0x10
  end

  # test "given a string returns the item that appears in both halves (10)" do
    #       1234567890123456789012345678901234567890123456
    #       1234567890123456789012312345678901234567890123
    #       ZqBPqBQnPLmqZsFqhsvFsLZ
    #       QMfSSMbbWddWbjbJSrgWgJf
    # data = "ZqBPqBQnPLmqZsFqhsvFsLZQMfSSMbbWddWbjbJSrgWgJf"
    # assert Aoc22.DayThree.find_duplicate(data) == 0x10
  # end

  test "given a string returns the item that appears in both halves (capital)" do
    data = "PmmdzqPrVvPwwTWBwg"
    assert Aoc22.DayThree.find_duplicate(data) == 42
  end

  test "given three bags finds the one item common amongst all three" do
    data = ["vJrwpWtwJgWrhcsFMMfFFhFp","jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL","PmmdzqPrVvPwwTWBwg"]
    assert Aoc22.DayThree.find_badge(data) == 18
  end

end
