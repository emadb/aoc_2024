defmodule Aoc.Day01Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_01.txt"
  @real_input "./lib/inputs/day_01.txt"

  test "part one (test)" do
    result = Aoc.Day01.part_one("ciao")

    assert result == "ciao"
  end
end
