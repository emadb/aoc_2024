defmodule Aoc.Day03Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_03.txt"
  @real_input "./lib/inputs/day_03.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day03.part_one(input)

    assert result == 161
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day03.part_one(input)
    assert result == 174_561_379
  end

  test "part two (test)" do
    input = Path.absname("./test/inputs/day_03_2.txt")
    result = Aoc.Day03.part_two(input)

    assert result == 48
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day03.part_two(input)
    assert result == 106_921_067
  end
end
