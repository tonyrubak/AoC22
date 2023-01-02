defmodule Aoc22DayOneTest do
  use ExUnit.Case
  doctest Aoc22.DayOne

  test "given a string returns an array of ints with :newelf markers" do
    data = "1000\n2000\n3000\n\n4000\n5000\n6000\n\n7000\n8000\n9000\n\n10000"
    assert Aoc22.DayOne.parse_data(data) == [1000,2000,3000,:newelf,4000,5000,6000,:newelf,7000,8000,9000,:newelf,10000]
  end

  test "given an array of ints with :newelf markers returns a summed list of ints" do
    data = [1000,2000,3000,:newelf,4000,5000,6000,:newelf,7000,8000,9000,:newelf,10000]
    assert Aoc22.DayOne.sum_elves(data) == [6000,15000,24000,10000]
  end

  test "given a string returns the max calories carried by any elf" do
    data = "1000\n2000\n3000\n\n4000\n5000\n6000\n\n7000\n8000\n9000\n\n10000"
    assert Aoc22.DayOne.solve(data) == 24000
  end
end
