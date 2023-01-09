defmodule Aoc22.DayEleven do
  def initial_state do
    [
      %{
        inspections: 0,
        items: [80],
        operation: fn x -> x * 5 end,
        test: fn
          x when rem(x,2) == 0 -> 4
          x when rem(x,2) != 0 -> 3
        end
      },
      %{
        inspections: 0,
        items: [75,83,74],
        operation: fn x -> x + 7 end,
        test: fn
          x when rem(x,7) == 0 -> 5
          x when rem(x,7) != 0 -> 6
        end
      },
      %{
        inspections: 0,
        items: [86,67,61,96,52,63,73],
        operation: fn x -> x + 5 end,
        test: fn
          x when rem(x,3) == 0 -> 7
          x when rem(x,3) != 0 -> 0
        end
      },
      %{
        inspections: 0,
        items: [85,83,55,85,57,70,85,52],
        operation: fn x -> x + 8 end,
        test: fn
          x when rem(x,17) == 0 -> 1
          x when rem(x,17) != 0 -> 5
        end
      },
      %{
        inspections: 0,
        items: [67,75,91,72,89],
        operation: fn x -> x + 4 end,
        test: fn
          x when rem(x,11) == 0 -> 3
          x when rem(x,11) != 0 -> 1
        end
      },
      %{
        inspections: 0,
        items: [66,64,68,92,68,77],
        operation: fn x -> x * 2 end,
        test: fn
          x when rem(x,19) == 0 -> 6
          x when rem(x,19) != 0 -> 2
        end
      },
      %{
        inspections: 0,
        items: [97,94,79,88],
        operation: fn x -> x * x end,
        test: fn
          x when rem(x,5) == 0 -> 2
          x when rem(x,5) != 0 -> 7
        end
      },
      %{
        inspections: 0,
        items: [77,85],
        operation: fn x -> x + 6 end,
        test: fn
          x when rem(x,13) == 0 -> 4
          x when rem(x,13) != 0 -> 0
        end
      }
    ]
  end

  def throw_item(monkeys,from,to) do
    %{operation: op} = Enum.at(monkeys,from)
    item =
      monkeys
      |> Enum.at(from)
      |> Map.get(:items)
      |> hd()
      |> op.()
      |> relax()

    monkeys = List.update_at(monkeys,from,fn monkey -> %{monkey | items: tl(monkey[:items])} end)
    List.update_at(monkeys, to, fn monkey -> %{monkey | items: monkey[:items] ++ [item]} end)
  end

  def relax(item), do: rem(item,2*3*5*7*11*13*17*19)

  def process_monkey(monkeys,_n,%{items: []}), do: monkeys
  def process_monkey(monkeys,n,%{items: [item|_items]} = monkey) do
    to_monkey =
      item
      |> monkey[:operation].()
      |> relax()
      |> monkey[:test].()
    monkeys = throw_item(monkeys,n,to_monkey)
    monkeys = List.update_at(monkeys,n,fn monkey -> %{monkey | inspections: monkey[:inspections] + 1} end)
    process_monkey(monkeys,n,Enum.at(monkeys,n))
  end

  def do_round(monkeys) do
    for i <- 0..length(monkeys)-1, reduce: monkeys do
      acc -> process_monkey(acc,i,Enum.at(acc,i))
    end
  end

  def do_rounds(monkeys, num_rounds) do
    for _ <- 1..num_rounds, reduce: monkeys do
      acc -> do_round(acc)
    end
  end

  def part_one(monkeys) do
    monkeys
    |> do_rounds(20)
    |> Enum.sort(fn l,r -> l[:inspections] >= r[:inspections] end)
    |> Enum.take(2)
    |> Enum.map(fn monkey -> monkey[:inspections] end)
    |> Enum.reduce(1,fn l,r -> l*r end)
  end

  def part_two(monkeys) do
    monkeys
    |> do_rounds(10000)
    |> Enum.sort(fn l,r -> l[:inspections] >= r[:inspections] end)
    |> Enum.take(2)
    |> Enum.map(fn monkey -> monkey[:inspections] end)
    |> Enum.reduce(1,fn l,r -> l*r end)
  end
end
