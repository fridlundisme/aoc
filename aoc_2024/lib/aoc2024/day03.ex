defmodule Aoc2024.Day03 do
  def part1(input) do
    scan_for_numbers(input)
    |> Enum.map(fn x -> x |> Enum.reduce(&(&1 * &2)) end)
    |> Enum.sum()
  end

  def part2(input) do
    re_ignore = ~r/don't\(\).+do\(\)|don't\(\).+$/sU

    Regex.split(re_ignore, input)
    |> Enum.map(fn x ->
      scan_for_numbers(x)
      |> Enum.reduce(0, fn x, acc ->
        acc + Enum.reduce(x, &(&1 * &2))
      end)
    end)
    |> Enum.sum()
  end

  def scan_for_numbers(input) do
    Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)/, input)
    |> List.flatten()
    |> Enum.map(&create_numbers/1)
  end

  def create_numbers(text) do
    Regex.scan(~r/\d+/, text)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
