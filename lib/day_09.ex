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
    |> checksum()
  end

  defp group_by_chars(input) do
    input
    |> Enum.chunk_by(& &1)
    |> Enum.filter(fn [char | _] -> char != "." end)
    |> Enum.map(fn group -> {List.first(group), length(group)} end)
  end

  defp defrag_blocks(disk) do
    do_defrag_blocks(group_by_chars(Enum.reverse(disk)), Enum.chunk_by(disk, & &1))
  end

  defp do_defrag_blocks([], disk) do
    Enum.flat_map(disk, fn x -> x end)
  end

  defp do_defrag_blocks([{s, count} | rest], disk) do
    space =
      Enum.find_index(disk, fn b ->
        Enum.at(b, 0) == "." && length(b) >= count
      end)

    block = Enum.find_index(disk, fn b -> Enum.at(b, 0) == s and length(b) == count end)

    new_disk =
      if is_nil(space) do
        disk
      else
        move(disk, block, space) |> merge_dot_blocks()
      end

    do_defrag_blocks(rest, new_disk)
  end

  def move(disk, index_block, index_space) when index_block > index_space do
    block_to_move = Enum.at(disk, index_block)
    block_to_replace = Enum.at(disk, index_space)

    size_to_move = length(block_to_move)
    size_to_replace = length(block_to_replace)

    disk = List.replace_at(disk, index_block, List.duplicate(".", size_to_move))

    disk = List.replace_at(disk, index_space, block_to_move)

    if size_to_replace > size_to_move do
      new_block = List.duplicate(".", size_to_replace - size_to_move)
      List.insert_at(disk, index_space + 1, new_block)
    else
      disk
    end
  end

  def move(disk, _, _), do: disk

  def merge_dot_blocks(disk) do
    Enum.reduce(disk, [], fn block, acc ->
      case {block, List.last(acc)} do
        {["." | _] = current, ["." | _] = last} ->
          List.replace_at(acc, -1, last ++ current)

        _ ->
          acc ++ [block]
      end
    end)
  end

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

    Enum.split(reversed_disk, index)
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

  defp checksum(disk) do
    {_, checksum} =
      Enum.reduce(disk, {0, 0}, fn e, {index, sum} ->
        n = if e == ".", do: 0, else: String.to_integer(e)
        {index + 1, sum + n * index}
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
