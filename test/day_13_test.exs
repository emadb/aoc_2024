defmodule Aoc.Day13Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_13.txt"
  @real_input "./lib/inputs/day_13.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day13.part_one(input)

    assert result == 480
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day13.part_one(input)
    assert result == 25751
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day13.part_two(input)

    assert result == 875_318_608_908
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day13.part_two(input)

    assert result == 108_528_956_728_655
  end
end
