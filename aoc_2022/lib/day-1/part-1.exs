defmodule FileReader do
  def read_lines(file) do
    split_file = Regex.split(~r{(\n\n)}, file, [])
    calculate_value(split_file) |> IO.inspect()
  end

  def calculate_value([head | tail]) do
    max(calculate_value(head), calculate_value(tail))
  end

  def calculate_value([]) do
    0
  end

  def calculate_value(elf_calories) do
    String.split(elf_calories, "\n", trim: true)
    |> Enum.map(fn cal -> String.to_integer(cal) end)
    |> Enum.sum()
  end
end

Helpers.Parsing.read_file() |> FileReader.read_lines()
