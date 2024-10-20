defmodule FileReader do
  def read_lines(file) do
    split_file = Regex.split(~r{(\n\n)}, file, [])
    now = Time.utc_now()
    calculate_value(split_file) |> Enum.sum() |> IO.puts()
    exec_time = Time.diff(Time.utc_now(), now, :millisecond)
    IO.puts("#{exec_time}ms")
  end

  def calculate_value([head | tail]) do
    [calculate_value(head) | calculate_value(tail)]
    |> Enum.sort(:desc)
    |> Enum.slice(0..2)
  end

  def calculate_value([]) do
    [0]
  end

  def calculate_value(elf_calories) do
    String.split(elf_calories, "\n", trim: true)
    |> Enum.map(fn cal -> String.to_integer(cal) end)
    |> Enum.sum()
  end
end

Helpers.Parsing.read_file() |> FileReader.read_lines()
