defmodule Aoc.Day20Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_20.txt"
  @real_input "./lib/inputs/day_20.txt"

  # test "part one (test)" do
  #   input = Path.absname(@test_input)
  #   result = Aoc.Day20.part_one(input)

  #   assert result == 0
  # end

  @tag timeout: :infinity
  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day20.part_one(input)
    assert result == 1293
  end

  # test "part two (test)" do
  #   input = Path.absname(@test_input)
  #   result = Aoc.Day20.part_two(input)

  #   assert result == input
  # end

  @tag timeout: :infinity
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day20.part_two(input)
    assert result == 977_747
  end
end
