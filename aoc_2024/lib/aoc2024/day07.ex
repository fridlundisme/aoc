defmodule Aoc2024.Day07 do
  def part1(input) do
    parse(input)
    |> evaluate_equations([:mult, :add])
    |> Enum.reduce(0, fn {total, result}, acc ->
      case Enum.find(result, &(&1 == total)) do
        nil -> acc
        _ -> total + acc
      end
    end)
  end

  def part2(_input) do
  end

  def parse(input) do
    input
    |> String.split("\n")
    |> Enum.map(fn row ->
      String.split(row, ":", trim: true)
    end)
    |> Enum.filter(fn val -> val != [] end)
    |> Enum.map(fn [h, t] ->
      {String.to_integer(h), String.split(t, " ", trim: true) |> Enum.map(&String.to_integer/1)}
    end)
  end

  def evaluate_equations(input, operations) do
    input
    |> Enum.map(fn {total, list} ->
      {total,
       Enum.reduce(list, [], fn val, acc ->
         [calc_next(val, acc, operations)] |> List.flatten()
       end)}
    end)
  end

  def calc_next(val, [], _), do: val

  def calc_next(nil, vals, _), do: vals

  def calc_next(val, [h | []], operations) do
    calc_next(nil, [calculate(val, h, operations)], operations)
  end

  def calc_next(val, [h | t], operations) do
    [calculate(val, h, operations) | calc_next(val, t, operations)]
  end

  def calculate(val1, val2, operations) when is_list(operations) do
    Enum.map(operations, fn operation ->
      calculate(val1, val2, operation)
    end)
  end

  def calculate(val1, val2, :mult) do
    val1 * val2
  end

  def calculate(val1, val2, :add) do
    val1 + val2
  end

  def calculate(val1, val2, :concat) do
    String.to_integer(Integer.to_string(val2) <> Integer.to_string(val1))
  end
end
