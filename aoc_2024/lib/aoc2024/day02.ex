defmodule Aoc2024.Day02 do
  alias Aoc2024.Input

  def part1(input) do
    map_values(input)
    |> Enum.map(
      &{length(&1),
       Enum.count(&1, fn x ->
         check_success(x)
       end)}
    )
    |> Enum.count(&check_success/1)
  end

  def part2(input) do
    map_values(input)
    |> Enum.map(
      &{length(&1),
       Enum.count(&1, fn x ->
         check_success(x)
       end), &1}
    )
    # Max errors allowed are 2, if more then removing 1 level will never be enough
    |> Enum.filter(fn {total, success_count, _} -> total - success_count <= 2 end)
    |> Enum.map_reduce(0, fn {total, success_count, vals}, acc ->
      cond do
        total == success_count ->
          {:ok, acc + 1}

        true ->
          {vals, acc}
      end
    end)
    |> then(fn {list, acc} ->
      {Enum.filter(list, &(&1 != :ok)), acc}
    end)
    |> then(fn {list, acc} ->
      {
        list
        |> Enum.map(fn row ->
          Enum.map(row, fn {_, _, val} -> val end)
        end),
        acc
      }
    end)
    |> then(fn {lists, acc} ->
      Enum.map(lists, fn list1 ->
        Enum.with_index(list1)
        |> Enum.each(fn list ->
          new_list = Enum.drop(list1, fn x -> nil end)
        end)
      end)
    end)
  end

  def map_values(input) do
    Input.split_input(input, :new_line)
    |> Enum.map(fn row ->
      Input.split_input(row, :spaces)
      |> Enum.map(&String.to_integer(&1))
      |> check_vals()
      |> Enum.reverse()
    end)
  end

  def check_success({x, x}), do: true
  def check_success({_, _}), do: false
  def check_success({_, true, _}), do: true
  def check_success({_, nil, _}), do: true
  def check_success({_, false, _}), do: false

  def check_vals(row) do
    check_vals(row, [])
  end

  def check_vals([_h | []], values) do
    values
  end

  def check_vals([first | _t] = all, [] = values) do
    check_vals(all, [{:first, nil, first} | values])
  end

  def check_vals([first, second | t], [] = values) do
    with {direction, success} <- second_derivative_ish(first, second) do
      check_vals([second | t], [{direction, success, second} | values])
    end
  end

  def check_vals([first, second | t], [{acc_dir, acc_success, _} | _t] = values) do
    with {direction, success} <- second_derivative_ish(first, second) do
      cond do
        acc_dir == direction ->
          check_vals([second | t], [{direction, success, second} | values])

        acc_dir == :equal && direction != :equal ->
          check_vals([second | t], [{direction, success, second} | values])

        acc_success == nil ->
          check_vals([second | t], [{direction, success, second} | values])

        true ->
          check_vals([second | t], [{direction, false, second} | values])
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
      _ -> {:equal, false}
    end
  end

  def diff_constraints(first, second) do
    abs(first - second) >= 1 and not (abs(first - second) > 3)
  end
end
