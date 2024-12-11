defmodule Aoc.Day11 do
  def part_one(input) do
    build_stones(input)
    |> blink(25)
    |> Enum.count()
  end

  def build_stones(input) do
    input
    |> InputFile.get_file()
    |> String.split(" ")
    |> Enum.map(&String.to_integer/1)
  end

  def blink(stones, 0), do: stones

  def blink(stones, n) do
    IO.inspect(n, label: "blinking")
    new_stones = Enum.flat_map(stones, &apply_rule/1)
    blink(new_stones, n - 1)
  end

  def apply_rule(0), do: [1]

  def apply_rule(n) do
    digits = Integer.digits(n)

    if even?(digits) do
      split_in_half(digits)
    else
      [n * 2024]
    end
  end

  def even?(digits), do: rem(length(digits), 2) == 0

  def split_in_half(digits) do
    middle = div(length(digits), 2)
    {a, b} = Enum.split(digits, middle)
    [String.to_integer(Enum.join(a)), String.to_integer(Enum.join(b))]
  end

  def part_two(input) do
    build_stones(input)
    |> blink(75)
    |> Enum.count()
  end
end
