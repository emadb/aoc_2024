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
    [string_map, string_commands] =
      input
      |> InputFile.get_file()
      |> String.split("\n\n")

    map = build_map(string_map)
    commands = build_commands(string_commands)
    map = double_map(map)

    final_map = move_d(commands, map)

    final_map
    |> Enum.filter(fn {_, v} -> v == "[" end)
    |> Enum.map(fn {{x, y}, "["} -> 100 * y + x end)
    |> Enum.sum()
  end

  defp move_d([], map), do: map

  defp move_d([command | rest], map) do
    robot = find_robot(map)
    next_pos = next(command, robot)

    new_map =
      case Map.get(map, next_pos) do
        "." ->
          move_robot(map, robot, next_pos)

        "#" ->
          map

        "[" ->
          {x, y} = next_pos
          map_box = move_box_d(map, {x, y}, {x + 1, y}, command)
          if map_box != map, do: move_robot(map_box, robot, next_pos), else: map_box

        "]" ->
          {x, y} = next_pos
          map_box = move_box_d(map, {x - 1, y}, {x, y}, command)
          if map_box != map, do: move_robot(map_box, robot, next_pos), else: map_box
      end

    move_d(rest, new_map)
  end

  defp move_box_d(map, {xl, yl}, {xr, yr}, "<") do
    case Map.get(map, {xl - 1, yl}) do
      "." ->
        map
        |> Map.put({xl, yl}, "]")
        |> Map.put({xr, yr}, ".")
        |> Map.put({xl - 1, yl}, "[")

      "#" ->
        map

      "]" ->
        map_box = move_box_d(map, {xl - 2, yl}, {xl - 1, yl}, "<")

        if map_box != map do
          map_box
          |> Map.put({xr, yr}, ".")
          |> Map.put({xl, yl}, "]")
          |> Map.put({xl - 1, yl}, "[")
        else
          map_box
        end
    end
  end

  defp move_box_d(map, {xl, yl}, {xr, yr}, ">") do
    case Map.get(map, {xr + 1, yr}) do
      "." ->
        map
        |> Map.put({xl, yl}, ".")
        |> Map.put({xr, yr}, "[")
        |> Map.put({xr + 1, yr}, "]")

      "#" ->
        map

      "[" ->
        map_box = move_box_d(map, {xr + 1, yr}, {xr + 2, yr}, ">")

        if map_box != map do
          map_box
          |> Map.put({xl, yl}, ".")
          |> Map.put({xr, yr}, "[")
          |> Map.put({xr + 1, yr}, "]")
        else
          map_box
        end
    end
  end

  defp move_box_d(map, {xl, yl}, {xr, yr}, "v") do
    dl = Map.get(map, {xl, yl + 1})
    dr = Map.get(map, {xr, yr + 1})

    case {dl, dr} do
      {".", "."} ->
        map
        |> Map.put({xl, yl}, ".")
        |> Map.put({xr, yr}, ".")
        |> Map.put({xl, yl + 1}, "[")
        |> Map.put({xr, yr + 1}, "]")

      {"#", _} ->
        map

      {_, "#"} ->
        map

      {".", "["} ->
        map_box = move_box_d(map, {xl + 1, yl + 1}, {xr + 1, yr + 1}, "v")

        if map_box != map do
          map_box
          |> Map.put({xl, yl}, ".")
          |> Map.put({xr, yr}, ".")
          |> Map.put({xl, yl + 1}, "[")
          |> Map.put({xr, yr + 1}, "]")
        else
          map_box
        end

      {"]", "."} ->
        map_box = move_box_d(map, {xl - 1, yl + 1}, {xr - 1, yr + 1}, "v")

        if map_box != map do
          map_box
          |> Map.put({xl, yl}, ".")
          |> Map.put({xr, yr}, ".")
          |> Map.put({xl, yl + 1}, "[")
          |> Map.put({xr, yr + 1}, "]")
        else
          map_box
        end

      {"[", "]"} ->
        map_box = move_box_d(map, {xl, yl + 1}, {xr, yr + 1}, "v")

        if map_box != map do
          map_box
          |> Map.put({xl, yl}, ".")
          |> Map.put({xr, yr}, ".")
          |> Map.put({xl, yl + 1}, "[")
          |> Map.put({xr, yr + 1}, "]")
        else
          map_box
        end

      {"]", "["} ->
        m1 = move_box_d(map, {xl - 1, yl + 1}, {xr - 1, yr + 1}, "v")
        m2 = move_box_d(map, {xl + 1, yl + 1}, {xr + 1, yr + 1}, "v")

        map_box =
          if m1 != map and m2 != map do
            move_box_d(map, {xl - 1, yl + 1}, {xr - 1, yr + 1}, "v")
            |> move_box_d({xl + 1, yl + 1}, {xr + 1, yr + 1}, "v")
          else
            map
          end

        if map_box != map do
          map_box
          |> Map.put({xl, yl}, ".")
          |> Map.put({xr, yr}, ".")
          |> Map.put({xl, yl + 1}, "[")
          |> Map.put({xr, yr + 1}, "]")
        else
          map_box
        end
    end
  end

  defp move_box_d(map, {xl, yl}, {xr, yr}, "^") do
    dl = Map.get(map, {xl, yl - 1})
    dr = Map.get(map, {xr, yr - 1})

    case {dl, dr} do
      {".", "."} ->
        update_map(map, {xl, yl}, {xr, yr}, "^")

      {"#", _} ->
        map

      {_, "#"} ->
        map

      {".", "["} ->
        map = move_box_d(map, {xl + 1, yl - 1}, {xr + 1, yr - 1}, "^")
        update_map(map, {xl, yl}, {xr, yr}, "^")

      {"]", "."} ->
        map = move_box_d(map, {xl - 1, yl - 1}, {xr - 1, yl - 1}, "^")
        update_map(map, {xl, yl}, {xr, yr}, "^")

      {"[", "]"} ->
        map = move_box_d(map, {xl, yl - 1}, {xr, yr - 1}, "^")
        update_map(map, {xl, yl}, {xr, yr}, "^")

      {"]", "["} ->
        m1 = move_box_d(map, {xl - 1, yr - 1}, {xr - 1, yl - 1}, "^")
        m2 = move_box_d(map, {xl + 1, yr - 1}, {xr + 1, yr - 1}, "^")

        map =
          if m1 != map and m2 != map do
            move_box_d(map, {xl - 1, yr - 1}, {xr - 1, yl - 1}, "^")
            |> move_box_d({xl + 1, yr - 1}, {xr + 1, yr - 1}, "^")
          else
            map
          end

        update_map(map, {xl, yl}, {xr, yr}, "^")
    end
  end

  defp update_map(map, {xl, yl}, {xr, yr}, "^") do
    map
    |> Map.put({xl, yl}, ".")
    |> Map.put({xr, yr}, ".")
    |> Map.put({xl, yl - 1}, "[")
    |> Map.put({xr, yr - 1}, "]")
  end

  defp double_map(map) do
    map
    |> Enum.reduce(%{}, fn {{x, y}, v}, acc ->
      Map.put(acc, {x * 2, y}, v)
    end)
    |> Enum.reduce(%{}, fn {{x, y}, v}, acc ->
      case v do
        "#" ->
          acc
          |> Map.put({x, y}, v)
          |> Map.put({x + 1, y}, v)

        "O" ->
          acc
          |> Map.put({x, y}, "[")
          |> Map.put({x + 1, y}, "]")

        "." ->
          acc
          |> Map.put({x, y}, v)
          |> Map.put({x + 1, y}, v)

        "@" ->
          acc
          |> Map.put({x, y}, v)
          |> Map.put({x + 1, y}, ".")
      end
    end)
  end

  defp print(map) do
    {mx, my} =
      Enum.reduce(map, {0, 0}, fn {{x, y}, _}, {mx, my} ->
        new_x = if x > mx, do: x, else: mx
        new_y = if y > my, do: y, else: my
        {new_x, new_y}
      end)

    for y <- 0..my do
      line =
        for x <- 0..mx do
          Map.get(map, {x, y})
        end

      IO.puts(line)
    end
  end
end
