defmodule Aoc.Day15Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_15.txt"
  @real_input "./lib/inputs/day_15.txt"

  test "part one (test easy)" do
    input = Path.absname("./test/inputs/day_15_easy.txt")
    result = Aoc.Day15.part_one(input)

    assert result == 2028
  end

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day15.part_one(input)

    assert result == 10092
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day15.part_one(input)
    assert result == 1_492_518
  end

  @tag :skip
  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day15.part_two(input)

    assert result == input
  end

  @tag :skip
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day15.part_two(input)
    assert result == input
  end
end
