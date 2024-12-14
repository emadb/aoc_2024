defmodule Aoc.Day14 do
  def part_one(input, width, height) do
    final_pos =
      input
      |> InputFile.get_file()
      |> String.split("\n")
      |> Enum.map(&parse_guard/1)
      |> Enum.map(&move(&1, 100, width, height))

    mid_x = div(width, 2)
    mid_y = div(height, 2)

    q1 =
      Enum.count(final_pos, fn {x, y} ->
        x >= 0 and x < mid_x and y >= 0 and y < mid_y
      end)

    q2 =
      Enum.count(final_pos, fn {x, y} ->
        x > mid_x and x < width and y >= 0 and y < mid_y
      end)

    q3 =
      Enum.count(final_pos, fn {x, y} ->
        x >= 0 and x < mid_x and y > mid_y and y < height
      end)

    q4 =
      Enum.count(final_pos, fn {x, y} ->
        x > mid_x and x < width and y > mid_y and y < height
      end)

    q1 * q2 * q3 * q4
  end

  defp move({{x, y}, {vx, vy}}, times, width, height) do
    new_x = rem(x + vx * times, width)
    new_y = rem(y + vy * times, height)

    new_x = if new_x < 0, do: new_x + width, else: new_x
    new_y = if new_y < 0, do: new_y + height, else: new_y

    {new_x, new_y}
  end

  defp parse_guard(line) do
    [p, v] = String.split(line, " ", trim: true)
    [x, y] = String.replace(p, "p=", "") |> String.split(",")
    [vx, vy] = String.replace(v, "v=", "") |> String.split(",")

    {{String.to_integer(x), String.to_integer(y)}, {String.to_integer(vx), String.to_integer(vy)}}
  end

  def part_two(input, width, height) do
    robots =
      input
      |> InputFile.get_file()
      |> String.split("\n")
      |> Enum.map(&parse_guard/1)

    for n <- 1..10000 do
      final_robots = Enum.map(robots, fn r -> move(r, n, width, height) end)
      if in_line(final_robots, 30), do: print_robots(final_robots, width, height, n)
    end
  end

  def in_line(robots, n) do
    robots
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.frequencies()
    |> Enum.any?(fn {_y, count} -> count >= n end)
  end

  defp print_robots(robots, width, height, iteration) do
    IO.inspect("#{iteration}----------")

    for y <- 0..(height - 1) do
      line =
        for x <- 0..(width - 1) do
          robot = Enum.find(robots, fn {xr, yr} -> {x, y} == {xr, yr} end)

          case robot do
            nil -> " "
            _ -> "*"
          end
        end

      IO.puts(line)
    end
  end
end
