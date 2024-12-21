defmodule Aoc.Day18Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_18.txt"
  @real_input "./lib/inputs/day_18.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day18.part_one(input, 6, 6, 12)

    assert result == 22
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day18.part_one(input, 70, 70)
    assert result == 372
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day18.part_two(input, 6, 6)

    assert result == {6, 1}
  end

  @tag timeout: :infinity
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day18.part_two(input, 70, 70)
    assert result == {25, 6}
  end
end
