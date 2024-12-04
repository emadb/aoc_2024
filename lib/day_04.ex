defmodule Aoc.Day04 do
  def part_one(input) do
    map = build_map(input)
    xs = find("X", map)

    Enum.map(xs, fn {x, y} -> find_xmas(map, x, y) end)
    |> Enum.sum()
  end

  defp find(letter, map) do
    Enum.filter(map, fn {_, v} -> v == letter end) |> Enum.map(fn {key, _value} -> key end)
  end

  defp build_map(input) do
    input
    |> InputFile.get_lines_string()
    |> Enum.with_index()
    |> Enum.map(fn {l, y} ->
      l
      |> String.graphemes()
      |> Enum.map(fn c -> {c, y} end)
      |> Enum.with_index()
    end)
    |> Enum.reduce(%{}, fn list, acc ->
      Enum.reduce(list, acc, fn {{c, y}, x}, acci ->
        Map.put(acci, {x, y}, c)
      end)
    end)
  end

  def find_xmas(map, x, y) do
    neighbords = [
      [{x, y - 1}, {x, y - 2}, {x, y - 3}],
      [{x + 1, y - 1}, {x + 2, y - 2}, {x + 3, y - 3}],
      [{x + 1, y}, {x + 2, y}, {x + 3, y}],
      [{x + 1, y + 1}, {x + 2, y + 2}, {x + 3, y + 3}],
      [{x, y + 1}, {x, y + 2}, {x, y + 3}],
      [{x - 1, y + 1}, {x - 2, y + 2}, {x - 3, y + 3}],
      [{x - 1, y}, {x - 2, y}, {x - 3, y}],
      [{x - 1, y - 1}, {x - 2, y - 2}, {x - 3, y - 3}]
    ]

    Enum.count(neighbords, fn dir ->
      Enum.map(dir, fn {xd, yd} -> Map.get(map, {xd, yd}) end)
      |> Enum.join() == "MAS"
    end)
  end

  def find_mas(map, x, y) do
    diagonals = [
      [{x + 1, y - 1}, {x + 1, y + 1}, {x - 1, y + 1}, {x - 1, y - 1}]
    ]

    Enum.count(diagonals, fn dir ->
      word =
        Enum.map(dir, fn {xd, yd} -> Map.get(map, {xd, yd}) end)
        |> Enum.join()

      Enum.member?(["SSMM", "MMSS", "SMMS", "MSSM"], word)
    end)
  end

  def part_two(input) do
    map = build_map(input)
    xs = find("A", map)

    Enum.map(xs, fn {x, y} -> find_mas(map, x, y) end)
    |> Enum.sum()
  end
end
