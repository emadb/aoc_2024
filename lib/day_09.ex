defmodule Aoc.Day09 do
  def part_one(input) do
    input
    |> parse_disk_map()
    |> defrag([])
    |> checksum()
  end

  def part_two(input) do
    input
    |> parse_disk_map()
    |> defrag_blocks()
    |> IO.inspect(label: ">>>>")
    # 00992111777.44.333....5555.6666.....8888..
    |> checksum()
  end

  defp defrag_blocks(disk) do
    do_defrag_blocks(disk, Enum.reverse(disk), [])
  end

  defp do_defrag_blocks([], _blocks, acc), do: acc

  # 00...111...2...333.44.5555.6666.777.888899
  defp do_defrag_blocks(["." | _] = disk, blocks, acc) do
    IO.inspect("--")
    {dots, rest} = find_dots(disk)
    {ids, rest2} = rfind_ids(blocks)

    subs =
      Enum.zip(dots, ids)
      |> Enum.map(fn {_, e} -> e end)

    dot_to_add =
      case length(dots) - length(ids) > 0 do
        true -> List.duplicate(".", length(dots) - length(ids))
        false -> []
      end

    IO.inspect({dots, rest}, label: "DOTS")
    IO.inspect({ids, rest2}, label: "ids")
    IO.inspect(dot_to_add, label: "dot_to_add")
    IO.inspect(subs, label: "subs")
    IO.inspect(acc, label: "acc")
    IO.inspect(dot_to_add ++ Enum.drop(rest, -1 * length(ids)), label: "RECUR")

    do_defrag_blocks(dot_to_add ++ Enum.drop(rest, -1 * length(ids)), rest2, acc ++ subs)
  end

  defp do_defrag_blocks([id | rest], blocks, acc) do
    do_defrag_blocks(rest, blocks, acc ++ [id])
  end

  # [".", "7", "7", "7", ".", "6", "6", "6", "6", ".", "5", "5", "5", "5", ".",
  #  "4", "4", ".", "3", "3", "3", ".", ".", ".", "2", ".", ".", ".", "1", "1",
  #  "1", ".", ".", ".", "0", "0"]
  def rfind_ids(reversed_disk) do
    reversed_disk = Enum.drop_while(reversed_disk, fn x -> x == "." end)
    first = List.first(reversed_disk)

    {index, _} =
      reversed_disk
      |> Enum.reduce_while({0, first}, fn e, {counter, id} ->
        if e != id or e == "." do
          {:halt, {counter, e}}
        else
          {:cont, {counter + 1, e}}
        end
      end)

    {ids, rest} = Enum.split(reversed_disk, index)
  end

  def find_dots(disk) do
    index =
      Enum.reduce_while(disk, 0, fn e, counter ->
        if e == "." do
          {:cont, counter + 1}
        else
          {:halt, counter}
        end
      end)

    Enum.split(disk, index)
  end

  defp defrag_blocks([id | disk], acc) do
    defrag_blocks(disk, acc ++ [id])
  end

  defp checksum(disk) do
    {_, checksum} =
      Enum.reduce(disk, {0, 0}, fn e, {index, sum} ->
        {index + 1, sum + String.to_integer(e) * index}
      end)

    checksum
  end

  defp defrag([], acc) do
    acc
  end

  defp defrag(["." | disk], acc) do
    {last, rem} = get_last(disk)

    case last do
      "." -> defrag(["."] ++ rem, acc)
      "" -> acc
      _ -> defrag(rem, acc ++ [last])
    end
  end

  defp defrag([id | disk], acc) do
    defrag(disk, acc ++ [id])
  end

  defp get_last(disk) do
    case List.last(disk) do
      nil -> {"", disk}
      last -> {last, List.delete_at(disk, length(disk) - 1)}
    end
  end

  defp parse_disk_map(input) do
    input
    |> InputFile.get_file()
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.reduce({0, []}, fn items, {id, acc} ->
      case items do
        [a, b] ->
          ids = List.duplicate(Integer.to_string(id), String.to_integer(a))
          dots = List.duplicate(".", String.to_integer(b))
          {id + 1, acc ++ ids ++ dots}

        [a] ->
          ids = List.duplicate(Integer.to_string(id), String.to_integer(a))
          {id + 1, acc ++ ids}
      end
    end)
    |> then(fn {_, list} -> list end)
  end
end
