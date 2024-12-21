defmodule Aoc.Day18 do
  def part_one(input, mx, my, max \\ 1024) do
    bugs =
      input
      |> InputFile.get_file()
      |> String.split("\n")
      |> Enum.take(max)
      |> Enum.map(fn line ->
        [x, y] = String.split(line, ",")
        {String.to_integer(x), String.to_integer(y)}
      end)

    map =
      for x <- 0..mx, y <- 0..my do
        {x, y}
      end

    map = Enum.reject(map, fn m -> Enum.member?(bugs, m) end)
    navigate(map, {0, 0}, {mx, my})
  end

  defp navigate(map, pos, end_p) do
    visited = MapSet.new()
    {score, last_pos} = do_find(map, [{0, pos}], visited, end_p)
    score
  end

  defp find_last(map, pos, end_p) do
    visited = MapSet.new()
    do_find(map, [{0, pos}], visited, end_p, pos)
  end

  defp do_find(map, queue, visited, end_p, last \\ {0, 0}) do
    dirs = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

    if Enum.empty?(queue) do
      {0, last}
    else
      {w, {x, y}} = Enum.min_by(queue, fn {w, _} -> w end)
      queue = Enum.reject(queue, fn xx -> xx == {w, {x, y}} end)

      if {x, y} == end_p do
        {w, {x, y}}
      else
        visited = MapSet.put(visited, {x, y})

        neighbors =
          Enum.reduce(dirs, [], fn {dx, dy}, acc ->
            next_pos = {x + dx, y + dy}

            cond do
              next_pos in visited ->
                acc

              Enum.member?(map, next_pos) == false ->
                acc

              true ->
                new_score = w + 1

                [{new_score, next_pos} | acc]
            end
          end)

        new_queue = queue ++ neighbors

        do_find(map, new_queue, visited, end_p, {x, y})
      end
    end
  end

  def part_two(input, mx, my) do
    bugs =
      input
      |> InputFile.get_file()
      |> String.split("\n")

    Enum.reduce_while(1..3450, {0, 0}, fn n, _ ->
      bugs =
        bugs
        |> Enum.take(n)
        |> Enum.map(fn line ->
          [x, y] = String.split(line, ",")
          {String.to_integer(x), String.to_integer(y)}
        end)

      last = List.last(bugs)

      map =
        for x <- 0..mx, y <- 0..my do
          {x, y}
        end

      map = Enum.reject(map, fn m -> Enum.member?(bugs, m) end)

      {_, {fx, fy}} = find_last(map, {0, 0}, {mx, my})

      case {fx, fy} do
        {^mx, ^my} ->
          {:cont, {mx, my}}

        {_, _} ->
          {:halt, last}
      end
    end)
  end
end
