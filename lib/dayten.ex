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
    |> elem(1)
    |> Enum.reverse()
    # |> then(fn list -> Enum.zip(list,1..length(list)) end)
    # |> Enum.map(fn {x,y} -> x*y end)
    # |> Enum.drop(19)
    # |> Enum.take_every(40)
    # |> Enum.sum
    |> Enum.reduce({0, ""}, &display/2)
    |> elem(1)
    |> IO.puts()
  end

  def execution_plan([noop: []] = instr,plan), do: [instr | plan]
  def execution_plan(instr, plan), do: [instr | [[noop: []] | plan]]

  def clock_cycle([noop: []], []), do: {1,[1]}
  def clock_cycle([noop: []], {last_x, hist}), do: {last_x, [last_x|hist]}
  def clock_cycle([sub: y], {_last_x, [x|_tl] = hist}), do: {x-y, [x|hist]}
  def clock_cycle([add: y], {_last_x, [x|_tl] = hist}), do: {x+y, [x|hist]}

  def display(x,{clk,output}) do
    output = output <> if clk |> beam_position() |> sprite_visible(x) do
      "#"
    else
      "."
    end
    output = output <> if rem(clk,40) == 39 do
      "\n"
    else
      ""
    end
    {clk + 1, output}
  end

  def sprite_visible(display_x, sprite_x) when display_x in sprite_x - 1 .. sprite_x + 1, do: true
  def sprite_visible(_,_), do: false

  def beam_position(clk), do: rem(clk,40)
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
