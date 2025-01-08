defmodule Aoc.Day19 do
  def part_one(input) do
    {towels, combinations} = parse(input)

    run_async(combinations, towels)
    |> Enum.count(fn x -> x > 0 end)
  end

  defp run_async(combinations, towels) do
    Task.async_stream(combinations, &check(&1, towels))
    |> Stream.map(fn {:ok, n} -> n end)
  end

  defp check("", _), do: 1

  defp check(combination, towels) do
    with nil <- Process.get(combination) do
      towels
      |> Enum.filter(fn t -> String.contains?(combination, t) end)
      |> Enum.reduce(0, fn towel, count ->
        case combination do
          <<^towel::binary, rest::binary>> -> check(rest, towels) + count
          _ -> count
        end
      end)
      |> tap(fn total -> Process.put(combination, total) end)
    end
  end

  def part_two(input) do
    {towels, combinations} = parse(input)

    run_async(combinations, towels)
    |> Enum.sum()
  end

  defp parse(input) do
    [towels, combinations] =
      input
      |> InputFile.get_file()
      |> String.split("\n\n")

    towels = String.split(towels, ", ")
    combinations = String.split(combinations, "\n")
    {towels, combinations}
  end
end
