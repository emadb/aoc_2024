defmodule Mix.Tasks.Day do
  use Mix.Task

  def run([]) do
    IO.puts("You must supply two arguments (day and part)")
  end

  def run([day]) do
    run([day, 1])
  end

  def run([day, part]) do
    Aoc.CodeGenerator.run(String.to_integer(day), part)
    |> IO.inspect()
  end
end
