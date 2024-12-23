defmodule Aoc.Day23 do
  def part_one(input) do
    input
    |> InputFile.get_file()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, "-") end)
    |> Enum.reduce(%{}, fn [a, b], map ->
      map
      |> Map.update(a, MapSet.new([b]), fn ms -> MapSet.put(ms, b) end)
      |> Map.update(b, MapSet.new([a]), fn ms -> MapSet.put(ms, a) end)
    end)
    |> build_trinagles()
    |> MapSet.to_list()
    |> Enum.filter(fn [a, b, c] -> starts_with_t(a) || starts_with_t(b) || starts_with_t(c) end)
    |> length()
  end

  def build_trinagles(map_set) do
    nodes = map_set |> Map.keys() |> Enum.sort()

    Enum.reduce(nodes, MapSet.new(), fn u, triangles ->
      neighbors_u = Map.get(map_set, u, MapSet.new())
      valid_vs = neighbors_u |> Enum.filter(&(&1 > u)) |> Enum.sort()

      Enum.reduce(valid_vs, triangles, fn v, triangles ->
        neighbors_v = Map.get(map_set, v, MapSet.new())

        valid_ws =
          MapSet.intersection(neighbors_u, neighbors_v)
          |> Enum.filter(&(&1 > v))

        Enum.reduce(valid_ws, triangles, fn w, triangles -> MapSet.put(triangles, [u, v, w]) end)
      end)
    end)
  end

  def starts_with_t(str), do: String.starts_with?(str, "t")

  def part_two(input) do
    sets =
      input
      |> InputFile.get_file()
      |> String.split("\n")
      |> Enum.map(fn line -> String.split(line, "-") end)
      |> Stream.map(fn [a, b] -> if a < b, do: [a, b], else: [b, a] end)
      |> Enum.reduce(%{}, fn [a, b], map ->
        Map.update(map, a, MapSet.new([b]), fn ms -> MapSet.put(ms, b) end)
      end)

    sets
    |> Map.keys()
    |> Enum.flat_map(&search_sets(sets, [&1], Enum.count(sets)))
    |> Enum.max_by(&Enum.count(&1))
    |> Enum.reverse()
    |> Enum.join(",")
  end

  def search_sets(connected, [c | cs], n) do
    neigh =
      connected
      |> Map.get(c, MapSet.new())
      |> Enum.filter(fn candidate -> Enum.all?(cs, &MapSet.member?(connected[&1], candidate)) end)

    case neigh do
      [] -> [[c | cs]]
      candidates -> Enum.flat_map(candidates, &search_sets(connected, [&1, c | cs], n - 1))
    end
  end
end
