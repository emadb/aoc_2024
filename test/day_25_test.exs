defmodule Aoc.Day25Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_25.txt"
  @real_input "./lib/inputs/day_25.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day25.part_one(input)

    assert result == 3
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day25.part_one(input)
    assert result == 3162
  end

  @tag :skip
  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day25.part_two(input)

    assert result == input
  end

  @tag :skip
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day25.part_two(input)
    assert result == input
  end
end
