defmodule Aoc.Day22Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_22.txt"
  @real_input "./lib/inputs/day_22.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day22.part_one(input)

    assert result == 37_327_623
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day22.part_one(input)
    assert result == 15_335_183_969
  end

  test "part two (test)" do
    input = Path.absname("./test/inputs/day_22_2.txt")
    result = Aoc.Day22.part_two(input)

    assert result == 23
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day22.part_two(input)
    assert result == 1696
  end
end
