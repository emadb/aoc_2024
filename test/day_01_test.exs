defmodule Aoc.Day01Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_01.txt"
  @real_input "./lib/inputs/day_01.txt"

  test "part one (test)" do
    result = Aoc.Day01.part_one(@test_input)
    assert result == 11
  end

  test "part one" do
    result = Aoc.Day01.part_one(@real_input)
    assert result == 1_197_984
  end

  test "part two (test)" do
    result = Aoc.Day01.part_two(@test_input)
    assert result == 31
  end

  test "part two" do
    result = Aoc.Day01.part_two(@real_input)
    assert result == 23_387_399
  end
end
