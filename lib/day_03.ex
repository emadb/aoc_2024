defmodule Aoc.Day03 do
  def part_one(input) do
    content = InputFile.get_file(input)

    Regex.scan(~r/mul\((?<f1>\d{1,3}),(?<f2>\d{1,3})\)/, content)
    |> Enum.map(fn [_, f1, f2] -> String.to_integer(f1) * String.to_integer(f2) end)
    |> Enum.sum()
  end

  def part_two(input) do
    bad_code = ~r/don't\(\)[\S\s]+?(do\(\)|$)/
    muls = ~r/mul\((\d+),(\d+)\)/

    content = InputFile.get_file(input)
    content = Regex.replace(bad_code, content, "")

    Regex.scan(muls, content)
    |> Enum.map(fn [_, f1, f2] -> String.to_integer(f1) * String.to_integer(f2) end)
    |> Enum.sum()
  end
end
