defmodule Aoc.Day09Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_09.txt"
  @real_input "./lib/inputs/day_09.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day09.part_one(input)

    assert result == 1928
  end

  @tag :skip
  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day09.part_one(input)
    assert result == 6_349_606_724_455
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day09.part_two(input)

    assert result == 2858
  end

  @tag skip: true, timeout: :infinity
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day09.part_two(input)
    assert result == 6_376_648_986_651
  end
end
