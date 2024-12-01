defmodule Aoc2024.Day01 do
  require Logger

  def part1(input) do
    rows = Aoc2024.Input.split_input(input, :new_line)
    {left, right} = get_lists(rows)

    Enum.zip_with(left, right, fn l, r ->
      abs(l - r)
    end)
    |> Enum.sum()
  end

  def part2(args) do
  end

  defp get_lists(rows) do
    {left, right} =
      rows
      |> Enum.reduce(
        {[], []},
        fn
          row, {left, right} ->
            [a, b] = row |> Aoc2024.Input.split_input(:spaces)
            a = String.to_integer(a)
            b = String.to_integer(b)
            {[a | left], [b | right]}
        end
      )

    left = Enum.sort(left)
    right = Enum.sort(right)
    {left, right}
  end
end
