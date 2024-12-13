defmodule Aoc.Day13 do
  def part_one(input) do
    input
    |> InputFile.get_file()
    |> String.split("\n\n")
    |> Enum.map(&build_data(&1, 0))
    |> Enum.map(&solve(&1, true))
    |> Enum.reduce(0, fn {a, b}, acc -> acc + a * 3 + b * 1 end)
  end

  def part_two(input) do
    input
    |> InputFile.get_file()
    |> String.split("\n\n")
    |> Enum.map(&build_data(&1, 10_000_000_000_000))
    |> Enum.map(&solve(&1, false))
    |> Enum.reduce(0, fn {a, b}, acc -> acc + a * 3 + b * 1 end)
  end

  defp solve(%{a: {xa, ya}, b: {xb, yb}, p: {xp, yp}}, limit?) do
    y = div(xp * ya - yp * xa, ya * xb - xa * yb)
    x = div(yp - y * yb, ya)

    if x * xa + y * xb == xp and x * ya + y * yb == yp and (!limit? or (x <= 100 and y <= 100)) do
      {x, y}
    else
      {0, 0}
    end
  end

  defp build_data(str, offset) do
    [a, b, p] = String.split(str, "\n", trim: true)

    [[_, xa, ya]] = Regex.scan(~r/Button A: X\+(?<xa>\d+), Y\+(?<ya>\d+)/, a)
    [[_, xb, yb]] = Regex.scan(~r/Button B: X\+(?<xb>\d+), Y\+(?<yb>\d+)/, b)
    [[_, px, py]] = Regex.scan(~r/Prize: X\=(?<xa>\d+), Y\=(?<ya>\d+)/, p)

    %{
      a: {String.to_integer(xa), String.to_integer(ya)},
      b: {String.to_integer(xb), String.to_integer(yb)},
      p: {String.to_integer(px) + offset, String.to_integer(py) + offset}
    }
  end
end
