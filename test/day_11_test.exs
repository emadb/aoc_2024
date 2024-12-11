defmodule Aoc.Day11Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_11.txt"
  @real_input "./lib/inputs/day_11.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day11.part_one(input)

    assert result == 55312
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day11.part_one(input)
    assert result == 212_655
  end

  @tag skip: true, timeout: :infinity
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day11.part_two(input)
    assert result == input
  end
end
