defmodule Aoc2024.Day02 do
  alias Aoc2024.Input

  def part1(input) do
    Input.split_input(input, :new_line)
    |> Enum.map(fn row ->
      Input.split_input(row, :spaces)
      |> Enum.map(&String.to_integer(&1))
      |> IO.inspect()
      |> check_vals()
    end)
    |> Enum.count(&(&1 == :safe))
  end

  def part2(args) do
  end

  def check_vals(row) do
    check_vals(row, nil)
  end

  def check_vals([_h | []], {status, _}) do
    status
  end

  def check_vals([first, second | t], nil) do
    with {direction, success} <- second_derivative_ish(first, second) do
      case success do
        true -> check_vals([second | t], {:safe, direction})
        false -> :unsafe
      end
    end
  end

  def check_vals([first, second | t], {_status, acc_dir}) do
    with {direction, success} <- second_derivative_ish(first, second),
         ^acc_dir <- direction do
      case success do
        true -> check_vals([second | t], {:safe, direction})
        false -> :unsafe
      end
    else
      _ ->
        :unsafe
    end
  end

  def second_derivative_ish(first, second) do
    cond do
      first == second -> :equal
      first > second -> :desc
      first < second -> :asc
    end
    |> case do
      :desc -> {:desc, diff_constraints(first, second)}
      :asc -> {:asc, diff_constraints(first, second)}
      _ -> {:halt, false}
    end
    |> IO.inspect(label: "Derivative test")
  end

  def diff_constraints(first, second) do
    abs(first - second) >= 1 and not (abs(first - second) > 3)
  end
end
