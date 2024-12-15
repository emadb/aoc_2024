defmodule Aoc.Day15 do
  alias ElixirSense.Core.Normalized.Macro.Env

  def part_one(input) do
    [string_map, string_commands] =
      input
      |> InputFile.get_file()
      |> String.split("\n\n")

    map = build_map(string_map)
    commands = build_commands(string_commands)
    final_map = move(commands, map)

    # print(final_map)
    final_map
    |> Enum.filter(fn {_, v} -> v == "O" end)
    |> Enum.map(fn {{x, y}, "O"} -> 100 * y + x end)
    |> Enum.sum()
  end

  defp move([], map), do: map

  defp move([command | rest], map) do
    robot = find_robot(map)
    next_pos = next(command, robot)

    # IO.inspect(%{
    #   command: command,
    #   robot: robot,
    #   next_pos: next_pos,
    #   map: Map.get(map, next_pos)
    # })

    new_map =
      case Map.get(map, next_pos) do
        "." ->
          move_robot(map, robot, next_pos)

        "#" ->
          map

        "O" ->
          map_box = move_box(map, next_pos, command)
          if map_box != map, do: move_robot(map_box, robot, next_pos), else: map_box
      end

    move(rest, new_map)
  end

  defp move_box(map, box, direction) do
    new_pos = next(direction, box)

    case Map.get(map, new_pos) do
      "." ->
        map
        |> Map.put(box, ".")
        |> Map.put(new_pos, "O")

      "#" ->
        map

      "O" ->
        map_box = move_box(map, new_pos, direction)

        if map_box != map do
          map_box
          |> Map.put(box, ".")
          |> Map.put(new_pos, "O")
        else
          map_box
        end
    end
  end

  defp move_robot(map, old_pos, new_pos) do
    map
    |> Map.put(old_pos, ".")
    |> Map.put(new_pos, "@")
  end

  defp next("^", {x, y}), do: {x, y - 1}
  defp next(">", {x, y}), do: {x + 1, y}
  defp next("<", {x, y}), do: {x - 1, y}
  defp next("v", {x, y}), do: {x, y + 1}

  defp find_robot(map) do
    {pos, "@"} = Enum.find(map, fn {_, v} -> v == "@" end)
    pos
  end

  defp build_commands(input) do
    String.graphemes(input)
    |> Enum.reject(fn x -> x == "\n" end)
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
      Map.put(acc, k, Map.get(e, k))
    end)
  end

  def part_two(input) do
    input
  end

  defp print(map) do
    for y <- 0..(8 - 1) do
      line =
        for x <- 0..(8 - 1) do
          Map.get(map, {x, y})
        end

      IO.puts(line)
    end
  end
end
