defmodule Aoc.Day19Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_19.txt"
  @real_input "./lib/inputs/day_19.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day19.part_one(input)

    assert result == 6
  end

  @tag timeout: :infinity
  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day19.part_one(input)
    assert result == 333
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day19.part_two(input)

    assert result == 16
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day19.part_two(input)
    assert result == 678_536_865_274_732
  end
end
