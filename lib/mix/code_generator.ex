defmodule Aoc.CodeGenerator do
  def run(day, part \\ 1) do

    string_day = to_string(day) |> String.pad_leading(2, "0")
    module = String.to_atom("Elixir.Aoc.Day#{string_day}")
    input = "../inputs/day_#{string_day}.txt"

    case part do
      1 -> module.part_one(input)
      2 -> module.part_two(input)
      _ -> {:error, "No such part #{part}"}
    end
  end

  def generate(day) do
    string_day = to_string(day) |> String.pad_leading(2, "0")

    template = """
    defmodule Aoc.Day#{string_day} do
      def part_one(input) do
        input
      end

      def part_two(input) do
        input
      end
    end
    """

    template_test = """
    defmodule Aoc.Day#{string_day}Test do
      use ExUnit.Case
      @test_input "./test/inputs/day_#{string_day}.txt"
      @real_input "./lib/inputs/day_#{string_day}.txt"

      test "part one (test)" do
        input = Path.absname(@test_input)
        result = Aoc.Day#{string_day}.part_one(input)

        assert result == nil
      end

      test "part one" do
        input = Path.absname(@real_input)
        result = Aoc.Day#{string_day}.part_one(input)
        assert result == nil
      end

      test "part two (test)" do
        input = Path.absname(@test_input)
        result = Aoc.Day#{string_day}.part_two(input)

        assert result == nil
      end

      test "part two" do
        input = Path.absname(@real_input)
        result = Aoc.Day#{string_day}.part_two(input)
        assert result == nil
      end

    end
    """

    filepath = Path.join([__DIR__, "../", "day_#{string_day}.ex"])
    input_filepath = Path.join([__DIR__, "../inputs/", "day_#{string_day}.txt"])

    testpath = Path.join([__DIR__, "../../test/", "day_#{string_day}_test.exs"])
    input_test = Path.join([__DIR__, "../../test/inputs/", "day_#{string_day}.txt"])

    with false <- File.exists?(filepath),
         :ok <- File.write!(filepath, template),
         :ok <- File.write!(input_filepath, ""),
         :ok <- File.write!(testpath, template_test),
         :ok <- File.write!(input_test, "") do
      IO.puts("Generated #{filepath}")
    else
      true -> IO.puts("File already exists at #{filepath}")
    end
  end
end
