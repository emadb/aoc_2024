defmodule Aoc.Day10 do
  def part_one(input) do
    map = build_map(input)
    zeros = find_zeros(map)

    Enum.map(zeros, fn z ->
      map
      |> navigate(z, [])
      |> Enum.map(&List.last/1)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part_two(input) do
    map = build_map(input)
    zeros = find_zeros(map)

    Enum.map(zeros, fn z ->
      map
      |> navigate(z, [])
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp find_zeros(map) do
    Enum.filter(map, fn {_, v} -> v == 0 end)
  end

  defp navigate(_map, {_, 9} = p, path) do
    [path ++ [p]]
  end

  defp navigate(map, {{x, y}, h}, path) do
    map
    |> Enum.filter(fn {{kx, ky}, _} ->
      {x + 1, y} == {kx, ky} ||
        {x - 1, y} == {kx, ky} ||
        {x, y + 1} == {kx, ky} ||
        {x, y - 1} == {kx, ky}
    end)
    |> Enum.filter(fn {_, v} -> v == h + 1 end)
    |> Enum.flat_map(fn p -> navigate(map, p, path ++ [p]) end)
  end

  defp build_map(input) do
    input
    |> InputFile.get_file()
    |> String.split("\n")
    |> Enum.with_index(fn line, y ->
      String.graphemes(line)
      |> Enum.with_index(fn c, x ->
        %{{x, y} => c}
      end)
    end)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.reduce(%{}, fn e, acc ->
      k = Enum.at(Map.keys(e), 0)
      Map.put(acc, k, String.to_integer(Map.get(e, k)))
    end)
  end
end
