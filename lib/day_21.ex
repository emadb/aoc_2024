defmodule Aoc.Day21 do
  @num_pad %{
    "A" => {2, 0},
    "0" => {1, 0},
    "1" => {0, 1},
    "2" => {1, 1},
    "3" => {2, 1},
    "4" => {0, 2},
    "5" => {1, 2},
    "6" => {2, 2},
    "7" => {0, 3},
    "8" => {1, 3},
    "9" => {2, 3}
  }

  @all_cmd %{
    {"A", "A"} => ["A"],
    {"A", "^"} => ["<", "A"],
    {"A", "v"} => ["<", "v", "A"],
    {"A", "<"} => ["v", "<", "<", "A"],
    {"A", ">"} => ["v", "A"],
    {"^", "A"} => [">", "A"],
    {"^", "^"} => ["A"],
    {"^", "v"} => ["v", "A"],
    {"^", "<"} => ["v", "<", "A"],
    {"^", ">"} => ["v", ">", "A"],
    {"v", "A"} => ["^", ">", "A"],
    {"v", "^"} => ["^", "A"],
    {"v", "v"} => ["A"],
    {"v", "<"} => ["<", "A"],
    {"v", ">"} => [">", "A"],
    {"<", "A"} => [">", ">", "^", "A"],
    {"<", "^"} => [">", "^", "A"],
    {"<", "v"} => [">", "A"],
    {"<", "<"} => ["A"],
    {"<", ">"} => [">", ">", "A"],
    {">", "A"} => ["^", "A"],
    {">", "^"} => ["<", "^", "A"],
    {">", "v"} => ["<", "A"],
    {">", "<"} => ["<", "<", "A"],
    {">", ">"} => ["A"]
  }

  def part_one(input) do
    seqs =
      input
      |> InputFile.get_file()
      |> String.split("\n")

    Agent.start_link(fn -> %{} end, name: __MODULE__)

    Enum.reduce(seqs, 0, fn s, acc ->
      moves = move_line(s, 2)
      acc + moves * numeric(s)
    end)
  end

  def part_two(input) do
    seqs =
      input
      |> InputFile.get_file()
      |> String.split("\n")

    Agent.start_link(fn -> %{} end, name: __MODULE__)

    Enum.reduce(seqs, 0, fn s, acc ->
      moves = move_line(s, 25)
      acc + moves * numeric(s)
    end)
  end

  def split(list, value) do
    list
    |> Enum.chunk_by(fn x -> x == value end)
    |> Enum.reject(fn chunk -> List.first(chunk) == value end)
  end

  def move_line(l, n) do
    pads =
      l
      |> String.graphemes()
      |> resolve_numpad("A", [])

    resolve_with_cache(pads, n, 0)
  end

  def get_cache(key) do
    Agent.get(__MODULE__, &Map.get(&1, key))
  end

  def put_cache(key, value) do
    Agent.update(__MODULE__, &Map.put(&1, key, value))
  end

  def resolve_with_cache(command, num_robots, kp) when kp == num_robots do
    String.length(command)
  end

  def resolve_with_cache(cmd, num_robots, keypad) do
    case get_cache({cmd, num_robots, keypad}) do
      nil ->
        cmd_splits =
          cmd
          |> get_next_command()
          |> Enum.join("")
          |> String.split("A")
          |> Enum.slice(0..-2//1)
          |> Enum.map(&(&1 <> "A"))

        new_res =
          Enum.reduce(cmd_splits, 0, fn c, acc ->
            acc + resolve_with_cache(c, num_robots, keypad + 1)
          end)

        put_cache({cmd, num_robots, keypad}, new_res)
        new_res

      res ->
        res
    end
  end

  def get_next_command(command) when is_binary(command) do
    command
    |> String.graphemes()
    |> get_next_command()
  end

  def get_next_command(command) do
    {_, output} =
      command
      |> Enum.reduce({"A", []}, fn c, {current, acc} ->
        action = Map.get(@all_cmd, {current, c})
        {c, acc ++ action}
      end)

    output
  end

  defp numeric(<<n::binary-size(3)>> <> "A") do
    String.to_integer(n)
  end

  def horizontal(0), do: []

  def horizontal(dx) do
    Enum.reduce(0..(abs(dx) - 1), [], fn _, acc ->
      if dx >= 0, do: acc ++ [">"], else: acc ++ ["<"]
    end)
  end

  def vertical(0), do: []

  def vertical(dy) do
    Enum.reduce(0..(abs(dy) - 1), [], fn _, acc ->
      if dy >= 0, do: acc ++ ["^"], else: acc ++ ["v"]
    end)
  end

  defp resolve_numpad([], _start, acc), do: acc

  defp resolve_numpad([c | rest], prev, acc) do
    {xs, ys} = @num_pad[prev]
    {x, y} = @num_pad[c]
    dx = x - xs
    dy = y - ys

    h = horizontal(dx)
    v = vertical(dy)

    this =
      cond do
        ys == 0 && x == 0 -> v ++ h
        xs == 0 && y == 0 -> h ++ v
        dx < 0 -> h ++ v
        dx >= 0 -> v ++ h
      end

    this = this ++ ["A"]
    resolve_numpad(rest, c, acc ++ this)
  end
end
