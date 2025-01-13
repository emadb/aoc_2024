defmodule Aoc.Day25 do
  def part_one(input) do
    maps =
      InputFile.get_file(input)
      |> String.split("\n\n")
      |> Enum.map(&build_map/1)

    keys = Enum.filter(maps, &key?/1)
    locks = Enum.filter(maps, &lock?/1)

    nk = Enum.map(keys, &count_key_pins/1)
    nl = Enum.map(locks, &count_key_pins/1)

    for [k0, k1, k2, k3, k4] <- nk, [l0, l1, l2, l3, l4] <- nl do
      [l0 + k0, l1 + k1, l2 + k2, l3 + k3, l4 + k4]
    end
    |> Enum.filter(fn c -> Enum.all?(c, fn x -> x <= 5 end) end)
    |> Enum.count()
  end

  defp count_key_pins(map) do
    Enum.reduce(0..4, [], fn x, cols ->
      col =
        Enum.reduce(0..6, 0, fn y, count ->
          if map[{x, y}] == "#", do: count + 1, else: count
        end)

      cols ++ [col - 1]
    end)
  end

  defp lock?(map) do
    [map[{0, 0}], map[{1, 0}], map[{2, 0}], map[{3, 0}], map[{4, 0}]] == ["#", "#", "#", "#", "#"]
  end

  defp key?(map) do
    [map[{0, 6}], map[{1, 6}], map[{2, 6}], map[{3, 6}], map[{4, 6}]] == ["#", "#", "#", "#", "#"]
  end

  defp build_map(input) do
    input
    |> String.split("\n")
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

  def part_two(input) do
    input
  end
end
