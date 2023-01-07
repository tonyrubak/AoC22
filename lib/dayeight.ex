defmodule Aoc22.DayEight do
  def read_data do
    {:ok, content} = File.read("data/day8.txt")
    content
  end

  def process(data) do
    {_, _, trees} =
      forest =
      data
      |> String.to_charlist()
      |> Enum.reduce({0, 0, []}, &reducer/2)

    # trees
    # |> Enum.map(fn tree -> visible(tree,forest) end)
    # |> Enum.map(
    #   fn
    #     true -> 1
    #     false -> 0
    #   end)
    # |> Enum.sum()

    trees
    |> Enum.map(fn x -> view(x, trees) end)
    # |> Enum.reverse
    |> Enum.max()
  end

  def reducer(10, {_x, y, res}), do: {0, y + 1, res}

  def reducer(n, {x, y, res}),
    do: {x + 1, y, [%{x: x, y: y, height: String.to_integer(List.to_string([n]))} | res]}

  def visible(%{x: 0}, _forest), do: true
  def visible(%{x: x_max}, {x_max, _y_max, _trees}), do: true
  def visible(%{y: 0}, _forest), do: true
  def visible(%{y: y_max}, {_x_max, y_max, _trees}), do: true

  def visible(tree, {_, _, trees}) do
    visible_from_north(tree, trees) or
      visible_from_south(tree, trees) or
      visible_from_west(tree, trees) or
      visible_from_east(tree, trees)
  end

  def visible_from_north(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:x] < tree[:x] end)
    |> Enum.filter(fn item -> item[:y] == tree[:y] end)
    |> Enum.map(fn item -> item[:height] < tree[:height] end)
    |> Enum.reduce(true, fn acc, res -> acc and res end)
  end

  def visible_from_south(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:x] > tree[:x] end)
    |> Enum.filter(fn item -> item[:y] == tree[:y] end)
    |> Enum.map(fn item -> item[:height] < tree[:height] end)
    |> Enum.reduce(true, fn acc, res -> acc and res end)
  end

  def visible_from_west(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:x] == tree[:x] end)
    |> Enum.filter(fn item -> item[:y] < tree[:y] end)
    |> Enum.map(fn item -> item[:height] < tree[:height] end)
    |> Enum.reduce(true, fn acc, res -> acc and res end)
  end

  def visible_from_east(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:x] == tree[:x] end)
    |> Enum.filter(fn item -> item[:y] > tree[:y] end)
    |> Enum.map(fn item -> item[:height] < tree[:height] end)
    |> Enum.reduce(true, fn acc, res -> acc and res end)
  end

  def view(tree, forest) do
    views = [&view_to_north/2, &view_to_south/2, &view_to_west/2, &view_to_east/2]

    views
    |> Enum.map(fn view_fn -> view_fn.(tree, forest) end)
    |> Enum.reduce(1, fn l, r -> l * r end)
  end

  def view_to_north(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:x] == tree[:x] end)
    |> Enum.filter(fn item -> item[:y] < tree[:y] end)
    |> Enum.sort(fn l, r -> l[:y] >= r[:y] end)
    |> Enum.reduce_while(0, fn
      x, acc ->
        if x[:height] < tree[:height] do
          {:cont, acc + 1}
        else
          {:halt, acc + 1}
        end
    end)
  end

  def view_to_south(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:x] == tree[:x] end)
    |> Enum.filter(fn item -> item[:y] > tree[:y] end)
    |> Enum.sort(fn l, r -> l[:y] <= r[:y] end)
    |> Enum.reduce_while(0, fn
      x, acc ->
        if x[:height] < tree[:height] do
          {:cont, acc + 1}
        else
          {:halt, acc + 1}
        end
    end)
  end

  def view_to_west(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:y] == tree[:y] end)
    |> Enum.filter(fn item -> item[:x] < tree[:x] end)
    |> Enum.sort(fn l, r -> l[:y] >= r[:y] end)
    |> Enum.reduce_while(0, fn
      x, acc ->
        if x[:height] < tree[:height] do
          {:cont, acc + 1}
        else
          {:halt, acc + 1}
        end
    end)
  end

  def view_to_east(tree, forest) do
    forest
    |> Enum.filter(fn item -> item[:y] == tree[:y] end)
    |> Enum.filter(fn item -> item[:x] > tree[:x] end)
    |> Enum.sort(fn l, r -> l[:x] <= r[:x] end)
    |> Enum.reduce_while(0, fn
      x, acc ->
        if x[:height] < tree[:height] do
          {:cont, acc + 1}
        else
          {:halt, acc + 1}
        end
    end)
  end
end

# test_data = 30373\n25512\n65332\n33549\n35390
