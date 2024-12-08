defmodule Aoc.Day08 do
  def part_one(input) do
    execute(input, &find_antinodes/3)
  end

  def part_two(input) do
    execute(input, &find_multi_antinodes/3)
  end

  defp execute(input, finder) do
    map = build_map(input)
    {mx, my} = find_max_xy(map)

    map
    |> Enum.reject(fn {_, v} -> v == "." end)
    |> group_by_freq()
    |> Enum.flat_map(fn {f, nodes} -> finder.(f, nodes, {mx, my}) end)
    |> Enum.flat_map(fn x -> x end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp in_map?({x, y}, {mx, my}),
    do: x <= mx and y <= my and x >= 0 and y >= 0

  defp group_by_freq(map) do
    # %{"A" => [{1,2}, {3, 4}, "0" => [] }
    Enum.reduce(map, %{}, fn {k, v}, acc ->
      coords = Map.get(acc, v, [])
      Map.put(acc, v, [k | coords])
    end)
  end

  defp find_max_xy(map) do
    Enum.reduce(map, {0, 0}, fn {{x, y}, _}, {mx, my} ->
      new_x = if x > mx, do: x, else: mx
      new_y = if y > my, do: y, else: my
      {new_x, new_y}
    end)
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

  defp find_antinodes(_freq, nodes, {mx, my}) do
    for {x1, y1} <- nodes, {x2, y2} <- nodes, {x1, y1} != {x2, y2} do
      dx = x2 - x1
      dy = y2 - y1
      a1 = {x1 - dx, y1 - dy}
      a2 = {x2 + dx, y2 + dy}
      Enum.filter([a1, a2], fn n -> in_map?(n, {mx, my}) end)
    end
  end

  defp find_multi_antinodes(_f, nodes, {mx, my}) do
    for {x1, y1} <- nodes, {x2, y2} <- nodes, {x1, y1} != {x2, y2} do
      dx = x2 - x1
      dy = y2 - y1
      find_harmonics({x1, y1}, dx, dy, {mx, my}) ++ find_harmonics({x2, y2}, dx, dy, {mx, my})
    end
  end

  defp find_harmonics({x, y}, dx, dy, {mx, my}) do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while([{x, y}], fn steps, acc ->
      antinode = {x - steps * dx, y - steps * dy}

      case in_map?(antinode, {mx, my}) do
        true -> {:cont, [antinode | acc]}
        false -> {:halt, acc}
      end
    end)
  end
end
