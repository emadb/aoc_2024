defmodule InputFile do
  def get_file(file_path) do
    File.read!(file_path)
  end

  def get_lines_integer(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn i ->
      {n, _} = Integer.parse(i)
      n
    end)
  end

  def get_line_integer(file_path) do
    file_path
    |> File.read!()
    |> String.split(",")
    |> Enum.map(fn i ->
      {n, _} = Integer.parse(i)
      n
    end)
  end

  def get_lines_string(file_path) do
    file_path
    |> File.read!()
    |> String.split("\n")
  end

  def get_line(file_path) do
    file_path
    |> File.read!()
  end
end
