defmodule Aoc2024.Day04 do
  def part1(input) do
    regex = ~r/(?=(XMAS)|(SAMX))/

    count_horizontal =
      count_instances(input, regex)

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
      |> Enum.reduce(0, fn x, acc -> count_instances(x, regex) + acc end)

    configs = [
      [sw: [0, :all]],
      [se: [0, :replace]],
      [ne: [grid_h - 1, :replace]],
      [nw: [grid_h - 1, :all]]
    ]

    diagonals = count_diagonals(grid, configs, grid_w, regex, :reduce)

    vertical + count_horizontal + diagonals
  end

  def part2(input) do
    regex = ~r/(?=(MS)|(SM))/

    %Grid{:grid => grid} = Grid.from_input(input)

    count_diagonals(grid, nil, nil, regex, :crossed)
  end

  def count_diagonals(grid, configs, size, regex, stragegy)

  def count_diagonals(grid, _, _, regex, :crossed) do
    new_grid = Grid.find(grid, "A")

    Enum.map(new_grid, fn {pos, _val} ->
      {cells_main, cells_anti} = get_diagonals(grid, pos)

      with main_match <- Regex.match?(regex, cells_main),
           anti_match <- Regex.match?(regex, cells_anti) do
        cond do
          main_match && anti_match -> :xmas
          true -> :miss
        end
      end
    end)
    |> Enum.count(&(&1 == :xmas))
  end

  def count_diagonals(grid, configs, size, regex, :reduce) do
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
        |> Enum.reduce(0, fn x, acc -> count_instances(x, regex) + acc end)

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
      Grid.next(grid, coordinates, direction)

    if direction == :nw do
      # IO.inspect({:old, {char, coordinates}, :new, {new_coords, new_char}})
    end

    string_from_diagonal(grid, new_coords, direction, new_char, [char | list])
  end

  def count_instances(input, regex) do
    vals =
      Regex.scan(regex, input)
      |> Enum.flat_map(&Enum.reject(&1, fn x -> x == "" || x == nil end))

    Enum.count(vals)
  end

  def get_diagonals(grid, pos) do
    main =
      Grid.adjacent_cells(grid, pos, :diagonal_main)
      |> Enum.map(fn {_, x} -> x end)
      |> List.to_string()

    anti =
      Grid.adjacent_cells(grid, pos, :diagonal_anti)
      |> Enum.map(fn {_, x} -> x end)
      |> List.to_string()

    {main, anti}
  end
end
