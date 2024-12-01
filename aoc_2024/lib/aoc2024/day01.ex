defmodule Aoc2024.Day01 do
  require Logger

  def part1(input) do
    {left, right} = get_lists(input)

    Enum.zip_with(left, right, fn l, r ->
      abs(l - r)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    {left, right} = get_lists(input)
    freq = Enum.frequencies(right)

    Enum.reduce(left, 0, fn val, acc ->
      acc + Map.get(freq, val, 0) * val
    end)
  end

  defp get_lists(input) do
    rows = Aoc2024.Input.split_input(input, :new_line)

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
