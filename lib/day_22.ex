defmodule Aoc.Day22 do
  def part_one(input) do
    secrets =
      input
      |> InputFile.get_file()
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    Enum.map(secrets, fn sn ->
      evolve(sn, 2000)
    end)
    |> Enum.sum()
  end

  defp evolve(number, times) do
    Enum.reduce(1..times, number, fn _, acc ->
      next_secret(acc)
    end)
  end

  def next_secret(n) do
    p1 =
      n
      |> mul64()
      |> mix(n)
      |> prune()

    p2 =
      p1
      |> div32()
      |> mix(p1)
      |> prune()

    p2
    |> mul2048()
    |> mix(p2)
    |> prune()
  end

  defp mul64(n), do: n * 64
  defp div32(n), do: floor(n / 32)
  defp mul2048(n), do: n * 2048

  defp mix(n, secret), do: :erlang.bxor(n, secret)
  defp prune(n), do: rem(n, 16_777_216)

  def part_two(input) do
    input
    |> InputFile.get_file()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn sn, map ->
      find_sequences(sn, 2000, map)
    end)
    |> Enum.max_by(fn {_, v} -> Enum.sum(v) end)
    |> elem(1)
    |> Enum.sum()
  end

  defp find_sequences(sn, times, map) do
    {_, _, _, new_map} =
      Enum.reduce(1..times, {sn, [rem(sn, 10)], rem(sn, 10), %{}}, fn idx,
                                                                      {n, list, prev_digit, acc} ->
        next_secret = next_secret(n)
        one_digit = rem(next_secret, 10)

        {seq, new_map} =
          if idx >= 4 do
            [_, b, c, d] = list
            seq = [b, c, d, one_digit - prev_digit]
            {seq, Map.update(acc, seq, [one_digit], fn l -> l ++ [one_digit] end)}
          else
            {list ++ [one_digit - prev_digit], acc}
          end

        {next_secret, seq, one_digit, new_map}
      end)

    Map.keys(new_map)
    |> Enum.reduce(map, fn k, acc ->
      v = Map.get(new_map, k) |> hd()
      Map.update(acc, k, [v], fn l -> l ++ [v] end)
    end)
  end
end
