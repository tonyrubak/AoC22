defmodule Aoc22.DaySix do
  def read_data do
    {:ok, content} = File.read("data/day6.txt")
    content
  end

  def process(data,n) do
    data = String.to_charlist(data)
    primer = Enum.take(data,n)
    data
    |> Enum.drop(n)
    |> Enum.reduce_while({n, primer},&stream_reducer/2)
  end

  def stream_reducer(data,acc) do
    {count, acc} = acc
    res = acc ++ [data]
    if Enum.uniq(res) != res do
      {:cont, {count + 1, tl(res)}}
    else
      {:halt, {count + 1, res}}
    end
  end
end
