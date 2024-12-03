defmodule Aoc2024.Day03 do
  def part1(input) do
    re = ~r/mul\(\d{1,3},\d{1,3}\)/

    Regex.scan(re, input)
    |> List.flatten()
    |> Enum.map(&create_numbers/1)
    |> Enum.map(fn x -> x |> Enum.reduce(&(&1 * &2)) end)
    |> Enum.sum()
  end

  def part2(input) do
  end

  def create_numbers(text) do
    Regex.scan(~r/\d+/, text)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end
