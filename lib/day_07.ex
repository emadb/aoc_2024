defmodule Aoc.Day07 do
  def part_one(input) do
    find_valid_combinations(input, ["+", "*"])
  end

  def part_two(input) do
    find_valid_combinations(input, ["+", "*", "||"])
  end

  defp parse_line(line) do
    [result, rest] = String.split(line, ":", trim: true)
    result = String.to_integer(result)
    numbers = String.split(rest, " ", trim: true) |> Enum.map(&String.to_integer/1)
    {result, numbers}
  end

  defp check_line({result, numbers}, operators) do
    case verify_result(result, numbers, operators) do
      nil -> {result, false}
      _ -> {result, true}
    end
  end

  defp verify_result(result, numbers, operators) do
    operators = generate_combinations(operators, Enum.count(numbers))

    Enum.find(operators, fn op ->
      operation = interleave(numbers, op)
      [r] = resolve_operation(operation)
      r == result
    end)
  end

  def resolve_operation([a, "+", b | rest]), do: resolve_operation([a + b | rest])
  def resolve_operation([a, "*", b | rest]), do: resolve_operation([a * b | rest])

  def resolve_operation([a, "||", b | rest]),
    do:
      resolve_operation([String.to_integer(Integer.to_string(a) <> Integer.to_string(b)) | rest])

  def resolve_operation(rest), do: rest

  def interleave(n, o) do
    Enum.zip(n, o ++ [:end])
    |> Enum.flat_map(fn
      {num, :end} -> [num]
      {num, op} -> [num, op]
    end)
  end

  defp find_valid_combinations(input, operators) do
    input
    |> InputFile.get_file()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.map(fn l -> check_line(l, operators) end)
    |> Enum.reduce(0, fn {r, s}, acc ->
      case s do
        true -> acc + r
        false -> acc
      end
    end)
  end

  def generate_combinations(operators, n) do
    Enum.to_list(1..(n - 1))
    |> Enum.reduce([[]], fn _, acc ->
      for combination <- acc, operator <- operators do
        combination ++ [operator]
      end
    end)
  end
end
