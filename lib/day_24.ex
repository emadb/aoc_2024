defmodule Aoc.Day24 do
  def part_one(input) do
    [state, gates] = parse(input)

    execute(state, gates)
    |> Enum.sort_by(&elem(&1, 0))
    |> Enum.filter(fn {k, _} -> String.starts_with?(k, "z") end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.with_index()
    |> Enum.reverse()
    |> Enum.reduce(0, fn {d, i}, acc ->
      acc + d * 2 ** i
    end)
  end

  def is_x(gate), do: String.starts_with?(gate, "x")
  def is_y(gate), do: String.starts_with?(gate, "y")
  def is_z(gate), do: String.starts_with?(gate, "z")

  def part_two(input) do
    [_state, gates] = parse(input)

    result =
      Enum.reduce(gates, [], fn {a, gate, b, res}, acc ->
        cond do
          # 3. If you have a XOR gate with inputs x, y, there must be another XOR gate with the output of this gate as an input. Search through all gates for an XOR-gate with this gate as an input; if it does not exist, your (original) XOR gate is faulty.
          gate == "XOR" &&
            ((is_x(a) && is_y(b)) || (is_y(a) && is_x(b))) &&
            a != "x00" && b != "x00" && a != "y00" && b != "y00" ->
            if Enum.find(gates, fn {a1, g1, b1, _r} ->
                 g1 == "XOR" && (a1 == res || b1 == res)
               end) == nil do
              acc ++ [res]
            else
              acc
            end

          # 1. If the output of a gate is z, then the operation has to be XOR unless it is the last bit.
          is_z(res) && gate != "XOR" && res != "z45" ->
            acc ++ [res]

          # 2. If the output of a gate is not z and the inputs are not x, y then it has to be AND / OR, but not XOR.
          !is_z(res) &&
            !is_x(a) &&
            !is_y(a) &&
            !is_x(b) &&
            !is_y(b) && gate == "XOR" ->
            acc ++ [res]

          # 4. Similarly, if you have an AND-gate, there must be an OR-gate with this gate as an input. If that gate doesn't exist, the original AND gate is faulty.
          gate == "AND" &&
            (is_x(a) || is_y(a) || is_x(b) || is_y(b)) &&
            a != "x00" && b != "x00" && a != "y00" && b != "y00" ->
            if is_nil(
                 Enum.find(gates, fn {a1, g1, b1, _r} ->
                   g1 == "OR" && (a1 == res || b1 == res)
                 end)
               ) do
              acc ++ [res]
            else
              acc
            end

          true ->
            acc
        end
      end)

    result
    |> Enum.sort()
    |> Enum.join(",")
  end

  defp execute(state, []), do: state

  defp execute(state, [{g1, op, g2, dest} | rest]) do
    gv1 = state[g1]
    gv2 = state[g2]

    if is_nil(gv1) or is_nil(gv2) do
      execute(state, rest ++ [{g1, op, g2, dest}])
    else
      res = apply_op(gv1, op, gv2)
      new_state = Map.put(state, dest, res)
      execute(new_state, rest)
    end
  end

  defp apply_op(g1, "AND", g2), do: :erlang.band(g1, g2)
  defp apply_op(g1, "OR", g2), do: :erlang.bor(g1, g2)
  defp apply_op(g1, "XOR", g2), do: :erlang.bxor(g1, g2)

  defp parse(input) do
    [state, gates] =
      input
      |> InputFile.get_file()
      |> String.split("\n\n")

    initial_state =
      String.split(state, "\n")
      |> Enum.reduce(%{}, fn s, map ->
        [wire, value] = String.split(s, ": ")
        Map.put(map, wire, String.to_integer(value))
      end)

    operations =
      String.split(gates, "\n")
      |> Enum.map(fn g ->
        [operation, res] = String.split(g, " -> ")
        [w1, op, w2] = String.split(operation, " ")

        {w1, op, w2, res}
      end)

    [initial_state, operations]
  end
end
