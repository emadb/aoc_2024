defmodule Aoc.Day14Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_14.txt"
  @real_input "./lib/inputs/day_14.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day14.part_one(input, 11, 7)

    assert result == 12
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day14.part_one(input, 101, 103)
    assert result == 233_709_840
  end

  @tag :skip
  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day14.part_two(input, 11, 7)

    assert result == input
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day14.part_two(input, 101, 103)
    assert true
  end
end
