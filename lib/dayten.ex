defmodule Aoc22.DayTen do
  def read_data do
    {:ok, content} = File.read("data/day10.txt")
    content
  end

  def read_test do
    {:ok, content} = File.read("data/day10test.txt")
    content
  end

  def process(data) do
    data
    |> String.splitter("\n")
    |> Enum.map(&Aoc22.DayTenParser.parse/1)
    |> Enum.map(fn it -> elem(it,1) end)
    |> Enum.reduce([], &execution_plan/2)
    |> Enum.reverse()
    |> Enum.reduce([], &clock_cycle/2)
    |> Enum.reverse()
    # |> then(fn list -> Enum.zip(list,1..length(list)) end)
    # |> Enum.map(fn {x,y} -> x*y end)
    |> Enum.drop(19)
    |> Enum.take_every(40)
    # |> Enum.sum
  end

  def execution_plan([noop: []] = instr,plan), do: [instr | plan]
  def execution_plan(instr, plan), do: [instr | [[noop: []] | plan]]

  def clock_cycle([noop: []], []), do: [1]
  def clock_cycle([noop: []], [x|_tl] = hist), do: [x|hist]
  def clock_cycle([sub: y], [x|_tl] = hist), do: [x - y | hist]
  def clock_cycle([add: y], [x|_tl] = hist), do: [x+y|hist]
end

defmodule Aoc22.DayTenParser do
  import NimbleParsec

  pos_integer = integer(min: 1)
  add = ignore(string("addx ")) |> concat(pos_integer) |> unwrap_and_tag(:add)
  sub = ignore(string("addx -")) |> concat(pos_integer) |> unwrap_and_tag(:sub)
  noop = ignore(string("noop")) |> tag(:noop)
  instr = choice([add,sub,noop])
  defparsec(:parse, instr)
end
