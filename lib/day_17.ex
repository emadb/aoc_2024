defmodule Aoc.Day17 do
  def part_one(input) do
    {reg_a, reg_b, reg_c, instr} = parse_input(input)
    state = initial_state(reg_a, reg_b, reg_c)
    %{out: out} = execute(instr, state)
    out
  end

  def part_two(program) do
    expected = Enum.reverse(program)
    search_a(program, expected, 0, 0)
  end


  defp search_a(_, target, a, depth) when depth == length(target), do: a

  defp search_a(program, target, a, depth) do
    Enum.find_value(0..7, fn i ->
      %{out: output} = execute(program, initial_state(a * 8 + i, 0, 0))
      if output != [] and hd(output) == Enum.at(target, depth) do
        result = search_a(program, target, a * 8 + i, depth + 1)
        if result != 0, do: result, else: nil
      end
    end)
  end


  defp xor(a, b), do: :erlang.bxor(a, b)

  def execute(instr, state) do
    case get_instruction(instr, state.ip) do
      [opcode, operand] ->
        new_state = execute_cmd(opcode, operand, state)
        execute(instr, new_state)

      nil ->
        state
    end
  end

  defp get_instruction(instructions, ip) do
    if length(instructions) >= ip + 2 do
      [Enum.at(instructions, ip), Enum.at(instructions, ip + 1)]
    else
      nil
    end
  end

  # adv
  def execute_cmd(0, op, state) do
    res = trunc(state.ra / 2 ** combo(op, state))
    %{state | ra: res, ip: state.ip + 2}
  end

  # bxl
  def execute_cmd(1, op, state) do
    res = xor(state.rb, op)
    %{state | rb: res, ip: state.ip + 2}
  end

  # bst
  def execute_cmd(2, op, state) do
    %{state | rb: rem(combo(op, state), 8), ip: state.ip + 2}
  end

  # jnz
  def execute_cmd(3, op, state) do
    if state.ra == 0 do
      %{state | ip: state.ip + 2}
    else
      %{state | ip: op}
    end
  end

  # bxc
  def execute_cmd(4, _op, state) do
    res = xor(state.rb, state.rc)
    %{state | rb: res, ip: state.ip + 2}
  end

  # out
  def execute_cmd(5, op, state) do
    res = rem(combo(op, state), 8)
    %{state | out: state.out ++ [res], ip: state.ip + 2}
  end

  # bdv
  def execute_cmd(6, op, state) do
    res = trunc(state.ra / 2 ** combo(op, state))
    %{state | rb: res, ip: state.ip + 2}
  end

  # cdv
  def execute_cmd(7, op, state) do
    res = trunc(state.ra / 2 ** combo(op, state))
    %{state | rc: res, ip: state.ip + 2}
  end

  defp combo(v, _) when v in [0, 1, 2, 3], do: v
  defp combo(4, state), do: state.ra
  defp combo(5, state), do: state.rb
  defp combo(6, state), do: state.rc

  def initial_state(reg_a, reg_b, reg_c) do
    %{
      ra: reg_a,
      rb: reg_b,
      rc: reg_c,
      ip: 0,
      out: []
    }
  end

  defp parse_input(input) do
    [reg, instr] =
      input
      |> InputFile.get_file()
      |> String.split("\n\n")

    [ra, rb, rc] = String.split(reg, "\n", trim: true)
    [_, reg_a] = String.split(ra, ": ", trim: true)
    reg_a = String.to_integer(reg_a)

    [_, reg_b] = String.split(rb, ": ", trim: true)
    reg_b = String.to_integer(reg_b)

    [_, reg_c] = String.split(rc, ": ", trim: true)
    reg_c = String.to_integer(reg_c)

    [_, instr] = String.split(instr, ": ", trim: true)
    instr = String.split(instr, ",", trim: true) |> Enum.map(fn c -> String.to_integer(c) end)

    {reg_a, reg_b, reg_c, instr}
  end
end
