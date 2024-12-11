defmodule Aoc.Day11 do
  def part_one(input) do
    build_stone_map(input)
    |> blink(25)
    |> Enum.sum()
  end

  def part_two(input) do
    build_stone_map(input)
    |> blink(75)
    |> Enum.sum()
  end

  defp build_stone_map(input) do
    input
    |> InputFile.get_file()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn c, acc ->
      Map.update(acc, c, 1, fn x -> x + 1 end)
    end)
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

  def apply_rule(map, 0, count) do
    Map.update(map, 1, count, &(&1 + count))
  end

  def apply_rule(map, stone, count) do
    if even?(stone) do
      {stone1, stone2} = split_stone(stone)

      map
      |> Map.update(stone1, count, &(&1 + count))
      |> Map.update(stone2, count, &(&1 + count))
    else
      new_key = stone * 2024
      Map.update(map, new_key, count, &(&1 + count))
    end
  end

  def even?(stone) do
    digits = Integer.digits(stone)
    rem(length(digits), 2) == 0
  end

  def split_stone(stone) do
    digits = Integer.digits(stone)
    middle = div(length(digits), 2)

    {s1, s2} = Enum.split(digits, middle)
    {Enum.join(s1) |> String.to_integer(), Enum.join(s2) |> String.to_integer()}
  end
end
