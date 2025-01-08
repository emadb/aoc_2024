defmodule Tree do
  defstruct [:node, :score, :direction, :children]
end

defmodule Aoc.Day16 do
  def part_one(input) do
    map =
      input
      |> InputFile.get_file()
      |> build_map()

    {start_pos, _} = Enum.find(map, fn {_k, v} -> v == "S" end)
    {end_pos, _} = Enum.find(map, fn {_k, v} -> v == "E" end)
    elem(navigate(map, start_pos, "E", end_pos), 0)
  end

  def part_two(input, score) do
    map =
      input
      |> InputFile.get_file()
      |> build_map()

    {start_pos, _} = Enum.find(map, fn {_, v} -> v == "S" end)
    {end_pos, _} = Enum.find(map, fn {_, v} -> v == "E" end)

    build_tree(map, start_pos)
    |> best_paths(score, end_pos)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def best_paths(tree, score, dest) do
    do_best_paths(tree, score, dest, [tree.node])
  end

  defp do_best_paths(%Tree{node: node, score: score, children: _}, target_score, dest, acc)
       when node == dest and score == target_score do
    [acc]
  end

  defp do_best_paths(%Tree{node: _, score: _, children: children}, target_score, dest, acc) do
    Enum.flat_map(children, fn child ->
      do_best_paths(child, target_score, dest, [child.node | acc])
    end)
  end

  def build_tree(map, start) do
    root = %Tree{node: start, score: 0, direction: "E", children: []}
    visited = MapSet.new([start])
    do_build_tree(map, root, visited)
  end

  defp do_build_tree(map, node, visited) do
    children =
      get_valid_moves(map, node.node, node.direction)
      |> Enum.reject(fn {pos, _d, _s} -> MapSet.member?(visited, pos) end)
      |> Enum.map(fn {pos, direction, move_score} ->
        child = %Tree{
          node: pos,
          score: node.score + move_score,
          direction: direction,
          children: []
        }

        new_visited = MapSet.put(visited, pos)
        do_build_tree(map, child, new_visited)
      end)

    %{node | children: children}
  end

  def get_valid_moves(map, {x, y}, direction) do
    Enum.reduce([{-1, 0}, {1, 0}, {0, -1}, {0, 1}], [], fn {dx, dy}, acc ->
      next_pos = {x + dx, y + dy}

      case map[next_pos] do
        "." -> [{next_pos, dir({dx, dy}), score({dx, dy}, direction)} | acc]
        "E" -> [{next_pos, dir({dx, dy}), score({dx, dy}, direction)} | acc]
        _ -> acc
      end
    end)
  end

  defp navigate(map, pos, dir, end_p) do
    visited = MapSet.new()
    {score, paths, v} = do_find(map, [{0, pos, dir}], visited, end_p)
    {score, paths, v}
  end

  defp do_find(map, queue, visited, end_p) do
    dirs = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

    {w, {x, y}, d} = Enum.min_by(queue, fn {w, _, _} -> w end)

    queue = Enum.reject(queue, fn xx -> xx == {w, {x, y}, d} end)

    if {x, y} == end_p do
      {w, {x, y}, visited}
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
              new_score = w + score({dx, dy}, d)

              [{new_score, next_pos, dir({dx, dy})} | acc]
          end
        end)

      new_queue = queue ++ neighbors

      do_find(map, new_queue, visited, end_p)
    end
  end

  defp dir({1, 0}), do: "E"
  defp dir({-1, 0}), do: "W"
  defp dir({0, 1}), do: "S"
  defp dir({0, -1}), do: "N"

  defp score({_, 0}, dir) when dir in ["E", "W"], do: 1
  defp score({_, 0}, dir) when dir in ["N", "S"], do: 1001
  defp score({0, _}, dir) when dir in ["N", "S"], do: 1
  defp score({0, _}, dir) when dir in ["E", "W"], do: 1001

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
end
