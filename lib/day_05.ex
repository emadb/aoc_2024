defmodule Aoc.Day05 do
  def part_one(input) do
    [rules, pages] =
      input
      |> InputFile.get_file()
      |> String.split("\n\n")

    rule_list = parse_rules(rules)

    pages
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn l -> valid?(l, rule_list) end)
    |> Enum.map(fn l -> Enum.at(l, div(length(l), 2)) end)
    |> Enum.sum()
  end

  def part_two(input) do
    [rules, pages] =
      input
      |> InputFile.get_file()
      |> String.split("\n\n")

    rule_list = parse_rules(rules)

    pages
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
    |> Enum.filter(fn l -> not_valid?(l, rule_list) end)
    |> Enum.map(fn l -> reorder(l, rule_list) end)
    |> Enum.map(fn l -> Enum.at(l, div(length(l), 2)) end)
    |> Enum.sum()
  end

  defp parse_line(line) do
    String.split(line, ",")
    |> Enum.map(fn i -> String.to_integer(i) end)
  end

  defp valid?([], _rules) do
    true
  end

  defp valid?([e | rest], rules) do
    precs = find_precs(rules, e)

    all =
      Enum.all?(precs, fn {prec, _} ->
        !Enum.member?(rest, prec)
      end)

    case all do
      true -> valid?(rest, rules)
      false -> false
    end
  end

  defp not_valid?([], _rules) do
    false
  end

  defp not_valid?([e | rest], rules) do
    precs = find_precs(rules, e)

    any =
      Enum.any?(precs, fn {prec, _} ->
        Enum.member?(rest, prec)
      end)

    case any do
      true -> true
      false -> not_valid?(rest, rules)
    end
  end

  defp find_precs(rules, e) do
    rules
    |> Enum.filter(fn {_, b} -> e == b end)
  end

  defp parse_rules(rules) do
    rules
    |> String.split("\n")
    |> Enum.map(fn l ->
      [a, b] = String.split(l, "|")
      {String.to_integer(a), String.to_integer(b)}
    end)
  end

  defp reorder(list, rules) do
    Enum.sort(list, fn a, b -> {a, b} in rules end)
  end
end
