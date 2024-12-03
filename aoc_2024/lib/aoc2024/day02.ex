defmodule Aoc2024.Day02 do
  alias Aoc2024.Input

  def part1(input) do
    Input.split_input(input, :new_line)
    |> Enum.map(fn row ->
      Input.split_input(row, :spaces)
      |> Enum.map(&String.to_integer(&1))
      |> check_vals()
      |> Enum.reverse()
    end)
    |> Enum.map(
      &{length(&1),
       Enum.count(&1, fn x ->
         check_success(x)
       end)}
    )
    |> Enum.count(&check_success/1)
  end

  def part2(args) do
    # Testa att returnera [{:safe|:unsafe, second_number}]
    # Då borde resultatet på test bli
    # [{:safe, 2}, {:unsafe, 7} {:safe, 8},{:safe, 9}]
    # |> Rerun without :unsafe
    # |>
    # FUCK doesn't work with this stuff as I need to remove the first
    # 4 2 3 4 5
    # # [{:unknown, 4}, {:desc, 2} {:asc, 3},{:asc, 4},{:asc, 5}]
  end

  def check_success({x, x}), do: true
  def check_success({_, _}), do: false
  def check_success({_, true, _}), do: true
  def check_success({_, false, _}), do: false

  def check_vals(row) do
    check_vals(row, [])
  end

  def check_vals([_h | []], values) do
    values
  end

  def check_vals([first, second | t], [] = values) do
    with {direction, success} <- second_derivative_ish(first, second) do
      check_vals([second | t], [{direction, success, {first, second}} | values])
    end
  end

  def check_vals([first, second | t], [{acc_dir, _, _} | _t] = values) do
    with {direction, success} <- second_derivative_ish(first, second) do
      cond do
        acc_dir == direction ->
          check_vals([second | t], [{direction, success, {first, second}} | values])

        true ->
          check_vals([second | t], [{direction, false, {first, second}} | values])
      end
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
