defmodule Aoc2024.Day04 do
  def part1(input) do
    count_horizontal =
      count_instances(input)

    %Grid{:grid => grid, height: grid_h, width: grid_w} =
      Grid.from_input(input)

    vertical =
      Enum.reduce(0..grid_w, [], fn x, acc ->
        [
          Enum.reduce(0..grid_h, [], fn y, acc ->
            [Map.get(grid, {x, y}, "") | acc] |> List.to_string()
          end)
          | acc
        ]
      end)
      |> Enum.reduce(0, fn x, acc -> count_instances(x) + acc end)

    configs = [
      [sw: [0, :all]],
      [se: [0, :replace]],
      [ne: [grid_h - 1, :replace]],
      [nw: [grid_h - 1, :all]]
    ]

    diagonals = count_diagonals(grid, configs, grid_w)

    vertical + count_horizontal + diagonals
  end

  def part2(args) do
  end

  def count_diagonals(grid, configs, size) do
    Enum.reduce(configs, 0, fn [k], acc ->
      {dir, [pos, stragegy]} = k

      values =
        Enum.map(0..(size - 1), fn x ->
          starting_char = Map.get(grid, {x, pos})
          string_from_diagonal(grid, {x, pos}, dir, starting_char)
        end)

      sum =
        if stragegy == :replace do
          List.replace_at(values, 0, "")
        else
          values
        end
        |> Enum.reduce(0, fn x, acc -> count_instances(x) + acc end)

      sum + acc
    end)
  end

  def string_from_diagonal(grid, coordinates, direction, char, list \\ [])

  def string_from_diagonal(_, _, _, nil, list) do
    # Order doesn't matter. If it starts to matter, reverse list here
    list |> Enum.reverse() |> List.to_string()
  end

  def string_from_diagonal(grid, coordinates, direction, char, list) do
    {new_coords, new_char} =
      Grid.move(grid, coordinates, direction)

    if direction == :nw do
      # IO.inspect({:old, {char, coordinates}, :new, {new_coords, new_char}})
    end

    string_from_diagonal(grid, new_coords, direction, new_char, [char | list])
  end

  def count_instances(input) do
    regex = ~r/(?=(XMAS)|(SAMX))/

    vals =
      Regex.scan(regex, input)
      |> Enum.flat_map(&Enum.reject(&1, fn x -> x == "" || x == nil end))

    Enum.count(vals)
  end
end
