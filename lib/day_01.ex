defmodule Aoc.Day01 do
  def part_one(input) do
    {l1, l2} = get_lists(input)

    Enum.zip(Enum.sort(l1), Enum.sort(l2))
    |> Enum.map(fn {e1, e2} -> abs(e1 - e2) end)
    |> Enum.sum()
  end

  def part_two(input) do
    {l1, l2} = get_lists(input)

    freq = Enum.frequencies(l2)

    Enum.map(l1, fn x -> x * Map.get(freq, x, 0) end)
    |> Enum.sum()
  end

  defp get_lists(input) do
    input
    |> InputFile.get_lines_string()
    |> Enum.map(fn l -> String.split(l, "   ") end)
    |> Enum.reduce({[], []}, fn [a, b], {l1, l2} ->
      {[String.to_integer(a) | l1], [String.to_integer(b) | l2]}
    end)
  end
end
