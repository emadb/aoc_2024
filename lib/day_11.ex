defmodule Aoc.Day11 do
  def part_one(input) do
    build_stone_map(input)
    |> blink(25)
    |> Enum.sum()
  end

  defp build_stone_map(input) do
    input
    |> InputFile.get_file()
    |> String.split(" ")
    |> Enum.reduce(%{}, fn c, acc ->
      Map.update(acc, c, 1, fn x -> x + 1 end)
    end)
  end

  def part_two(input) do
    build_stone_map(input)
    |> blink(75)
    |> Enum.sum()
  end

  def blink(a, blinks) do
    Enum.reduce(1..blinks, a, fn _, acc -> apply_rules(acc) end)
    |> Enum.map(fn {_k, v} -> v end)
  end

  defp apply_rules(stones) do
    Enum.reduce(stones, %{}, fn {stone, count}, acc ->
      apply_rule(acc, stone, count)
    end)
  end

  def apply_rule(map, "0", count) do
    Map.update(map, "1", count, &(&1 + count))
  end

  def apply_rule(map, stone, count) do
    if rem(String.length(stone), 2) == 0 do
      {first_half, second_half} = split_stone(stone)

      map
      |> Map.update(first_half, count, &(&1 + count))
      |> Map.update(second_half, count, &(&1 + count))
    else
      new_key = Integer.to_string(String.to_integer(stone) * 2024)
      Map.update(map, new_key, count, &(&1 + count))
    end
  end

  def split_stone(stone) do
    half_length = div(String.length(stone), 2)
    first_half = String.slice(stone, 0, half_length)

    second_half =
      String.slice(stone, half_length, String.length(stone) - half_length)
      |> String.to_integer()
      |> Integer.to_string()

    {first_half, second_half}
  end
end
