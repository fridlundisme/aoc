defmodule Aoc2024.Day11 do
  def part1(input) do
    blink(input, 25)
  end

  def part2(input) do
    blink(input, 75)
  end

  def blink(input, count) do
    input =
      String.split(input)
      |> Enum.map(&String.to_integer/1)

    Enum.reduce(1..count, input, fn x, acc ->
      acc
      # |> parallel_map(&rules/1)
      |> Enum.map(&rules(&1, count - x))
      |> List.flatten()
      |> IO.inspect(label: "After #{x} blinks", charlists: :as_lists)
    end)
    |> Enum.count()
  end

  defp parallel_map(list, func) do
    list
    |> Task.async_stream(func, timeout: :infinity)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  def rules(0, _), do: 1

  def rules(digit, _iterations_togo) do
    digits = Integer.digits(digit)
    l = length(digits)

    cond do
      l == 1 ->
        digit * 2024

      rem(l, 2) == 0 ->
        Enum.chunk_every(digits, trunc(l / 2))
        |> Enum.map(&Integer.undigits/1)

      true ->
        digit * 2024
    end
  end
end
