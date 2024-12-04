defmodule Aoc2024.Day04 do
  def part1(input) do
    count_horizontal =
      count_instances(input)

    %Grid{:grid => grid, height: grid_h, width: grid_w} =
      Grid.from_input(input)

    x_list =
      Enum.map(0..(grid_w - 1), fn x ->
        starting_char = Map.get(grid, {x, 0})
        string_from_diagonal(grid, {x, 0}, :se, starting_char)
      end)
      |> List.replace_at(0, "")
      |> Enum.reduce(0, fn x, acc -> count_instances(x) + acc end)

    y_list =
      Enum.map(0..(grid_w - 1), fn x ->
        starting_char = Map.get(grid, {x, 0})
        string_from_diagonal(grid, {x, 0}, :sw, starting_char)
      end)
      |> Enum.reduce(0, fn x, acc -> count_instances(x) + acc end)

    x2_list =
      Enum.map(0..(grid_w - 1), fn x ->
        starting_char = Map.get(grid, {x, grid_h - 1})
        string_from_diagonal(grid, {x, grid_h - 1}, :ne, starting_char)
      end)
      |> List.replace_at(0, "")
      |> Enum.reduce(0, fn x, acc -> count_instances(x) + acc end)

    y2_list =
      Enum.map(0..(grid_w - 1), fn x ->
        starting_char = Map.get(grid, {x, grid_h - 1})
        string_from_diagonal(grid, {x, grid_h - 1}, :nw, starting_char)
      end)
      |> Enum.reduce(0, fn x, acc -> count_instances(x) + acc end)

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

    vertical + count_horizontal + y_list + y2_list + x_list + x2_list
  end

  def part2(args) do
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
