defmodule Aoc2024.Day10 do
  def part1(input) do
    get_trails(input)
    |> Enum.reduce(fn list, acc ->
      [Enum.uniq_by(list, fn {pos, x} -> {pos, x} end) | acc]
    end)
    |> List.flatten()
    |> Enum.count(fn {_, val} -> val == 9 end)
  end

  def part2(input) do
    get_trails(input)
    |> List.flatten()
    |> Enum.count(fn {_, val} -> val == 9 end)
  end

  def get_trails(input) do
    %Grid{grid: grid} =
      Grid.from_input(input,
        char_type: fn x -> String.codepoints(x) |> Enum.map(&String.to_integer/1) end
      )

    starting_points = Grid.find(grid, 0)

    Enum.map(
      starting_points,
      &march(grid, &1)
    )
  end

  def march(grid, adjacent, acc \\ [])

  def march(_grid, [], acc) do
    acc
  end

  def march(grid, [h | t], acc) do
    march(grid, h, march(grid, t, acc))
  end

  def march(grid, {starting_point, val}, acc) do
    adjacent =
      Grid.adjacent_cells(grid, starting_point, :cardinal)
      |> Enum.filter(fn {_, val2} ->
        if val + 1 == val2 do
          true
        else
          false
        end
      end)

    case adjacent do
      [{key, 9} | t] ->
        march(grid, t, [{key, 9} | acc])

      [] ->
        [{starting_point, val} | acc]

      [h | adjacent] ->
        march(grid, [h | adjacent], [h | acc])
    end
  end
end
