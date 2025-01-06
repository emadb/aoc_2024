defmodule Aoc.Day20 do
  def part_one(input) do
    map = build_map(input)

    {start_pos, _} = Enum.find(map, fn {_k, v} -> v == "S" end)
    {end_pos, _} = Enum.find(map, fn {_k, v} -> v == "E" end)

    {_original_time, _visited, paths} =
      navigate(map, [{0, start_pos}], MapSet.new(), end_pos, %{}, %{})

    path = reconstruct_path(paths, start_pos, end_pos)

    path
    |> Enum.with_index()
    |> Enum.flat_map(fn {{x, y}, idx} ->
      cheat(path, idx, 2, {x, y})
    end)
    |> Enum.reduce(0, fn dist, acc ->
      cond do
        dist >= 100 -> acc + 1
        true -> acc
      end
    end)
  end

  def part_two(input) do
    map = build_map(input)

    {start_pos, _} = Enum.find(map, fn {_k, v} -> v == "S" end)
    {end_pos, _} = Enum.find(map, fn {_k, v} -> v == "E" end)

    {_original_time, _visited, paths} =
      navigate(map, [{0, start_pos}], MapSet.new(), end_pos, %{}, %{})

    path = reconstruct_path(paths, start_pos, end_pos)

    path
    |> Enum.with_index()
    |> Enum.flat_map(fn {{x, y}, idx} ->
      cheat(path, idx, 20, {x, y})
    end)
    |> Enum.reduce(0, fn dist, acc ->
      cond do
        dist >= 100 -> acc + 1
        true -> acc
      end
    end)
  end

  def cheat(path, idx, orginal_time, ref) do
    path
    |> Enum.with_index()
    |> Enum.reduce([], fn {{x, y}, curr}, acc ->
      dist = manhattan(ref, {x, y})
      delta = curr - idx - dist

      if dist <= orginal_time && delta > 0 do
        acc ++ [delta]
      else
        acc
      end
    end)
  end

  def manhattan({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  defp navigate(_map, [], visited, _end_p, _distances, paths), do: {0, visited, paths}

  defp navigate(map, queue, visited, end_p, distances, paths) do
    {w, {x, y}} = Enum.min_by(queue, fn {w, _} -> w end)
    queue = Enum.reject(queue, fn xx -> xx == {w, {x, y}} end)

    if {x, y} == end_p do
      {w, visited, paths}
    else
      visited = MapSet.put(visited, {x, y})

      {d, p, neighbors} =
        Enum.reduce([{-1, 0}, {1, 0}, {0, -1}, {0, 1}], {distances, paths, []}, fn {dx, dy},
                                                                                   {d, p, q} ->
          next_pos = {x + dx, y + dy}
          next_weight = w + 1

          cond do
            next_pos in visited ->
              {d, p, q}

            not_valid(map, next_pos) ->
              {d, p, q}

            Map.get(distances, next_pos, :infinity) <= next_weight ->
              {d, p, q}

            true ->
              {
                Map.put(d, next_pos, next_weight),
                Map.put(p, next_pos, {x, y}),
                q ++ [{next_weight, next_pos}]
              }
          end
        end)

      new_queue = queue ++ neighbors

      navigate(map, new_queue, visited, end_p, d, p)
    end
  end

  defp reconstruct_path(paths, start_p, end_p) do
    Stream.unfold(end_p, fn
      ^start_p -> nil
      current -> {current, Map.get(paths, current)}
    end)
    |> Enum.reverse()
    |> then(&[start_p | &1])
  end

  defp not_valid(map, pos),
    do: Map.has_key?(map, pos) == false || Map.get(map, pos) == "#"

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
