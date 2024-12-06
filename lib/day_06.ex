defmodule Aoc.Day06 do
  def part_one(input) do
    map = build_map(input)
    {xg, yg} = find_guard(map)

    map
    |> Map.put({xg, yg}, ".")
    |> navigate({xg, yg}, :N, MapSet.new())
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part_two(input) do
    map = build_map(input)
    {xg, yg} = find_guard(map)

    map = Map.put(map, {xg, yg}, ".")

    navigate(map, {xg, yg}, :N, MapSet.new())
    |> Enum.map(fn {x, y, _} -> {x, y} end)
    |> Enum.uniq()
    |> Enum.reject(&(&1 == {xg, yg}))
    |> Enum.map(fn pos ->
      Task.async(fn ->
        Map.put(map, pos, "#")
        |> loop?({xg, yg}, :N, MapSet.new())
      end)
    end)
    |> Task.await_many()
    |> Enum.filter(fn x -> x end)
    |> Enum.count()
  end

  defp loop?(map, {xg, yg}, :N, visited) do
    if MapSet.member?(visited, {xg, yg, :N}) do
      true
    else
      next_pos = {xg, yg - 1}

      case Map.get(map, next_pos) do
        "." -> loop?(map, next_pos, :N, MapSet.put(visited, {xg, yg, :N}))
        "#" -> loop?(map, {xg, yg}, :E, MapSet.put(visited, {xg, yg, :N}))
        nil -> false
      end
    end
  end

  defp loop?(map, {xg, yg}, :E, visited) do
    if MapSet.member?(visited, {xg, yg, :E}) do
      true
    else
      next_pos = {xg + 1, yg}

      case Map.get(map, next_pos) do
        "." -> loop?(map, next_pos, :E, MapSet.put(visited, {xg, yg, :E}))
        "#" -> loop?(map, {xg, yg}, :S, MapSet.put(visited, {xg, yg, :E}))
        nil -> false
      end
    end
  end

  defp loop?(map, {xg, yg}, :S, visited) do
    if MapSet.member?(visited, {xg, yg, :S}) do
      true
    else
      next_pos = {xg, yg + 1}

      case Map.get(map, next_pos) do
        "." -> loop?(map, next_pos, :S, MapSet.put(visited, {xg, yg, :S}))
        "#" -> loop?(map, {xg, yg}, :W, MapSet.put(visited, {xg, yg, :S}))
        nil -> false
      end
    end
  end

  defp loop?(map, {xg, yg}, :W, visited) do
    if MapSet.member?(visited, {xg, yg, :W}) do
      true
    else
      next_pos = {xg - 1, yg}

      case Map.get(map, next_pos) do
        "." -> loop?(map, next_pos, :W, MapSet.put(visited, {xg, yg, :W}))
        "#" -> loop?(map, {xg, yg}, :N, MapSet.put(visited, {xg, yg, :W}))
        nil -> false
      end
    end
  end

  defp navigate(map, {xg, yg}, :N, visited) do
    next_pos = {xg, yg - 1}

    case Map.get(map, next_pos) do
      "." -> navigate(map, next_pos, :N, MapSet.put(visited, {xg, yg, :N}))
      "#" -> navigate(map, {xg, yg}, :E, visited)
      nil -> MapSet.put(visited, {xg, yg, :N})
    end
  end

  defp navigate(map, {xg, yg}, :E, visited) do
    next_pos = {xg + 1, yg}

    case Map.get(map, next_pos) do
      "." -> navigate(map, next_pos, :E, MapSet.put(visited, {xg, yg, :E}))
      "#" -> navigate(map, {xg, yg}, :S, visited)
      nil -> MapSet.put(visited, {xg, yg, :E})
    end
  end

  defp navigate(map, {xg, yg}, :S, visited) do
    next_pos = {xg, yg + 1}

    case Map.get(map, next_pos) do
      "." -> navigate(map, next_pos, :S, MapSet.put(visited, {xg, yg, :S}))
      "#" -> navigate(map, {xg, yg}, :W, visited)
      nil -> MapSet.put(visited, {xg, yg, :S})
    end
  end

  defp navigate(map, {xg, yg}, :W, visited) do
    next_pos = {xg - 1, yg}

    case Map.get(map, next_pos) do
      "." -> navigate(map, next_pos, :W, MapSet.put(visited, {xg, yg, :W}))
      "#" -> navigate(map, {xg, yg}, :N, visited)
      nil -> MapSet.put(visited, {xg, yg, :W})
    end
  end

  defp find_guard(map) do
    {pos, _} = Enum.find(map, fn {_key, value} -> value == "^" end)
    pos
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
