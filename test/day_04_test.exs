defmodule Aoc.Day04Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_04.txt"
  @real_input "./lib/inputs/day_04.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day04.part_one(input)

    assert result == 18
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day04.part_one(input)
    assert result == 2654
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day04.part_two(input)

    assert result == 9
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day04.part_two(input)
    assert result == 1990
  end
end
