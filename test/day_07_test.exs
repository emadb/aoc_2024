defmodule Aoc.Day07Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_07.txt"
  @real_input "./lib/inputs/day_07.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day07.part_one(input)

    assert result == 3749
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day07.part_one(input)
    assert result == 3_351_424_677_624
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day07.part_two(input)

    assert result == 11387
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day07.part_two(input)
    assert result == 204_976_636_995_111
  end
end
