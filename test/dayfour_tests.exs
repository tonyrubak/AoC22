defmodule Aoc22DayFourTest do
  use ExUnit.Case

  test "given two ranges determines if one completely contains the other (yes)" do
    data1 = 2..8
    data2 = 3..7
    assert Aoc22.DayFour.proper_subset(data1,data2) == true
  end

  test "given two ranges determines if one completely contains the other (no)" do
    data1 = 2..4
    data2 = 6..8
    assert Aoc22.DayFour.proper_subset(data1,data2) == false
  end

  test "processes test data correctly" do
    data = "2-4,6-8\n2-3,4-5\n5-7,7-9\n2-8,3-7\n6-6,4-6\n2-6,4-8"
    assert Aoc22.DayFour.process_data(data) == 2
  end

  ### Possible cases
  ### l1 < l2, h1 < h2 -> 0..10, 1..11 -> false
  test "correctly categorizes 0..10, 1..11 as false" do
    data = "0-10,1-11"
    assert Aoc22.DayFour.process_line(data) == 0
  end
  ### l1 < l2, h1 > h2 -> 0..10, 1..9 -> true
  test "correctly categorizes 0..10, 1..9 as true" do
    data = "0-10,1-9"
    assert Aoc22.DayFour.process_line(data) == 1
  end
  ### l1 > l2, h1 < h2 -> 1..9, 0..10 -> true
  test "correctly categorizes 1..9, 0..10 as true" do
    data = "1-9,0-10"
    assert Aoc22.DayFour.process_line(data) == 1
  end
  ### l1 > l2, h1 > h2 -> 1..10, 0..9 -> false
  test "correctly categorizes 1..9, 0..10 as false" do
    data = "1-10,0-9"
    assert Aoc22.DayFour.process_line(data) == 0
  end

  test "correctly categorizes 1..1, 1..1 as true" do
    data = "1-1,1-1"
    assert Aoc22.DayFour.process_line(data) == 1
  end

  test "correctly categorizes 14..39, 14..85 as true" do
    data = "14-39,14-85"
    assert Aoc22.DayFour.process_line(data) == 1
  end
end
