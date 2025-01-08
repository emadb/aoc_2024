defmodule Aoc.Day17Test do
  use ExUnit.Case
  @test_input "./test/inputs/day_17.txt"
  @real_input "./lib/inputs/day_17.txt"

  test "part one (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day17.part_one(input)

    assert result == [4, 6, 3, 5, 6, 3, 5, 2, 1, 0]
  end

  test "2,6" do
    state = Aoc.Day17.initial_state(0, 0, 9)
    new_state = Aoc.Day17.execute([2, 6], state)
    assert new_state.rb == 1
  end

  test "5,0,5,1,5,4" do
    state = Aoc.Day17.initial_state(10, 0, 0)
    new_state = Aoc.Day17.execute([5, 0, 5, 1, 5, 4], state)
    assert new_state.out == [0, 1, 2]
  end

  test "0,1,5,4,3,0" do
    state = Aoc.Day17.initial_state(2024, 0, 0)
    new_state = Aoc.Day17.execute([0, 1, 5, 4, 3, 0], state)
    assert new_state.out == [4, 2, 5, 6, 7, 7, 7, 7, 3, 1, 0]
    assert new_state.ra == 0
  end

  test "1, 7" do
    state = Aoc.Day17.initial_state(0, 29, 0)
    new_state = Aoc.Day17.execute([1, 7], state)
    assert new_state.rb == 26
  end

  test "4, 0" do
    state = Aoc.Day17.initial_state(0, 2024, 43690)
    new_state = Aoc.Day17.execute([4, 0], state)
    assert new_state.rb == 44354
  end

  test "part one" do
    input = Path.absname(@real_input)
    result = Aoc.Day17.part_one(input)
    assert result == [1, 5, 3, 0, 2, 5, 2, 5, 3]
  end

  test "part two (test)" do
    input = Path.absname(@test_input)
    result = Aoc.Day17.part_two([0, 3, 5, 4, 3, 0])

    assert result == 117_440
  end

  @tag timeout: :infinity
  test "part two" do
    input = Path.absname(@real_input)
    result = Aoc.Day17.part_two([2, 4, 1, 3, 7, 5, 4, 1, 1, 3, 0, 3, 5, 5, 3, 0])
    assert result = 9_641_146_161_661
  end
end
