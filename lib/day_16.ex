defmodule Aoc.Day16 do
  def part_one(input) do
    map =
      input
      |> InputFile.get_file()
      |> build_map()

    {start_pos, _} = Enum.find(map, fn {k, v} -> v == "S" end)
    {end_pos, _} = Enum.find(map, fn {k, v} -> v == "E" end)
    navigate(map, start_pos, "E", end_pos)
  end

  defp navigate(map, pos, dir, end_p) do
    visited = MapSet.new()
    {score, _, _} = do_find(map, [{0, pos, dir}], visited, end_p)
    score
  end

  defp do_find(map, queue, visited, end_p) do
    dirs = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

    {w, {x, y}, d} = Enum.min_by(queue, fn {w, _, _} -> w end)

    queue = Enum.reject(queue, fn xx -> xx == {w, {x, y}, d} end)

    if {x, y} == end_p do
      {w, {x, y}, d}
    else
      visited = MapSet.put(visited, {x, y})

      neighbors =
        Enum.reduce(dirs, [], fn {dx, dy}, acc ->
          next_pos = {x + dx, y + dy}

          cond do
            next_pos in visited ->
              acc

            is_nil(Map.get(map, next_pos)) ->
              acc

            true ->
              new_weight = w + score({dx, dy}, d)
              new_dir = new_dir({dx, dy})

              [{new_weight, next_pos, new_dir} | acc]
          end
        end)

      new_queue = queue ++ neighbors

      do_find(map, new_queue, visited, end_p)
    end
  end

  defp new_dir({1, 0}), do: "E"
  defp new_dir({-1, 0}), do: "W"
  defp new_dir({0, 1}), do: "S"
  defp new_dir({0, -1}), do: "N"

  defp score({_, 0}, dir) when dir in ["E", "W"] do
    1
  end

  defp score({_, 0}, dir) when dir in ["N", "S"] do
    1001
  end

  defp score({0, _}, dir) when dir in ["N", "S"] do
    1
  end

  defp score({0, _}, dir) when dir in ["E", "W"] do
    1001
  end

  defp build_map(input) do
    input
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

      if Map.get(e, k) != "#" do
        Map.put(acc, k, Map.get(e, k))
      else
        acc
      end
    end)
  end

  def part_two(input) do
    map =
      input
      |> InputFile.get_file()
      |> build_map()

    {start_pos, _} = Enum.find(map, fn {k, v} -> v == "S" end)
    {end_pos, _} = Enum.find(map, fn {k, v} -> v == "E" end)
    navigate(map, start_pos, "E", end_pos)
  end
end
