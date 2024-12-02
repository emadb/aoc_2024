defmodule Aoc.Day02 do
  def part_one(input) do
    list =
      input
      |> InputFile.get_file()
      |> parse_file()

    Enum.count(list, fn l -> list_safe?(l) end)
  end

  def part_two(input) do
    list =
      input
      |> InputFile.get_file()
      |> parse_file()

    Enum.count(list, fn l -> list_safe?(l) || sublist_safe?(l) end)
  end

  def sublist_safe?(list) do
    Enum.find(
      0..(length(list) - 1),
      fn i ->
        list
        |> List.delete_at(i)
        |> list_safe?()
      end
    )
  end

  def list_safe?(levels) do
    qs = Enum.zip_with(levels, tl(levels), &delta/2)
    Enum.all?(qs, &(&1 == :up)) || Enum.all?(qs, &(&1 == :down))
  end

  def delta(a, b) when a > b and a - b <= 3, do: :down
  def delta(a, b) when a < b and b - a <= 3, do: :up
  def delta(_, _), do: :nope

  defp parse_file(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn l -> String.split(l, " ") end)
    |> Enum.map(fn l -> Enum.map(l, fn x -> String.to_integer(x) end) end)
  end
end
