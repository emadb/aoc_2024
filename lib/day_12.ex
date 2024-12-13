defmodule Aoc.Day12 do
  def part_one(input) do
    regions =
      input
      |> build_map()
      |> find_regions()

    Enum.map(regions, fn r -> get_area(r) * get_perimeter(r) end)
    |> Enum.sum()
  end

  def part_two(input) do
    regions =
      input
      |> build_map()
      |> find_regions()

    Enum.map(regions, fn r -> get_area(r) * get_sides(r) end)
    |> Enum.sum()
  end

  defp get_sides(list) do
    Enum.reduce(list, 0, fn {x, y}, acc ->
      north = Enum.any?(list, fn {xl, yl} -> xl == x and yl == y - 1 end)
      east = Enum.any?(list, fn {xl, yl} -> xl == x + 1 and yl == y end)
      south = Enum.any?(list, fn {xl, yl} -> xl == x and yl == y + 1 end)
      west = Enum.any?(list, fn {xl, yl} -> xl == x - 1 and yl == y end)

      north_east = Enum.any?(list, fn {xl, yl} -> xl == x + 1 and yl == y - 1 end)
      north_west = Enum.any?(list, fn {xl, yl} -> xl == x - 1 and yl == y - 1 end)
      south_east = Enum.any?(list, fn {xl, yl} -> xl == x + 1 and yl == y + 1 end)
      south_west = Enum.any?(list, fn {xl, yl} -> xl == x - 1 and yl == y + 1 end)

      a = if !north && !east, do: 1, else: 0
      b = if !north && !west, do: 1, else: 0
      c = if !south && !east, do: 1, else: 0
      d = if !south && !west, do: 1, else: 0
      e = if north && east && !north_east, do: 1, else: 0
      f = if north && west && !north_west, do: 1, else: 0
      g = if south && east && !south_east, do: 1, else: 0
      h = if south && west && !south_west, do: 1, else: 0

      acc + a + b + c + d + e + f + g + h
    end)
  end

  defp get_area(list), do: Enum.count(list)

  defp get_perimeter(list) do
    Enum.reduce(list, 0, fn {x, y}, per ->
      per + free_sides(list, {x, y})
    end)
  end

  defp free_sides(list, {x, y}) do
    [{x, y + 1}, {x, y - 1}, {x + 1, y}, {x - 1, y}]
    |> Enum.count(fn n -> not Enum.member?(list, n) end)
  end

  defp find_regions(map) do
    map
    |> Enum.reduce({[], MapSet.new()}, fn {coord, letter}, {regions, visited} ->
      if MapSet.member?(visited, coord) do
        {regions, visited}
      else
        {region, new_visited} = find_region(map, letter, [coord], [], visited)
        {[region | regions], new_visited}
      end
    end)
    |> elem(0)
  end

  defp find_region(_, _, [], region, visited), do: {region, visited}

  defp find_region(map, letter, [{x, y} | rest], region, visited) do
    if MapSet.member?(visited, {x, y}) do
      find_region(map, letter, rest, region, visited)
    else
      case Map.get(map, {x, y}) do
        ^letter ->
          neighbors = find_neighbors(map, {x, y})

          find_region(
            map,
            letter,
            rest ++ neighbors,
            [{x, y} | region],
            MapSet.put(visited, {x, y})
          )

        _ ->
          find_region(map, letter, rest, region, visited)
      end
    end
  end

  defp find_neighbors(map, {x, y}) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(&Map.has_key?(map, &1))
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
      Map.put(acc, k, Map.get(e, k))
    end)
  end
end
