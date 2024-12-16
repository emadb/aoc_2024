defmodule Aoc.Day16Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_16.txt"
  @real_input "./lib/inputs/day_16.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day16.part_one(input)

    assert result == 7036
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day16.part_one(input)
    assert result == 91464
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day16.part_two(input)

    assert result == 45
  end

  @tag :skip
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day16.part_two(input)
    assert result == input
  end
end
