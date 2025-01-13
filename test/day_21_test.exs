defmodule Aoc.Day21Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_21.txt"
  @real_input "./lib/inputs/day_21.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day21.part_one(input)

    assert result == 126_384
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day21.part_one(input)
    assert result == 174_124
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day21.part_two(input)

    assert result == 154_115_708_116_294
  end

  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day21.part_two(input)
    assert result == 216_668_579_770_346
  end
end
