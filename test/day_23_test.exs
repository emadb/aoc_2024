defmodule Aoc.Day23Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_23.txt"
  @real_input "./lib/inputs/day_23.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day23.part_one(input)

    assert result == 7
  end

  @tag timeout: :infinity
  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day23.part_one(input)
    assert result == 1370
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day23.part_two(input)

    assert result == "co,de,ka,ta"
  end

  @tag timeout: :infinity
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day23.part_two(input)
    assert result == "am,au,be,cm,fo,ha,hh,im,nt,os,qz,rr,so"
  end
end
