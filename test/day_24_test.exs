defmodule Aoc.Day24Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_24.txt"
  @real_input "./lib/inputs/day_24.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day24.part_one(input)

    assert result == 2024
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day24.part_one(input)
    assert result == 49_520_947_122_770
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day24.part_two(input)

    assert result == "ffh,mjb,tgd,wpb,z02,z03,z05,z06,z07,z08,z10,z11"
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day24.part_two(input)
    assert result == "gjc,gvm,qjj,qsb,wmp,z17,z26,z39"
  end
end
