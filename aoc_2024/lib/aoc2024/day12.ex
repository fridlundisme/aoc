defmodule Aoc2024.Day12 do
  def part1(input) do
    %Grid{grid: grid} = Grid.from_input(input)

    {result, _} =
      Enum.map_reduce(grid, grid, fn {pos, val}, acc_grid ->
        if Map.has_key?(acc_grid, pos) do
          {new_grid, {neighbours, count}} =
            find_neighbours({acc_grid, {[], 0}}, {pos, val})

          new_grid =
            Map.drop(new_grid, Enum.map(neighbours, fn {pos, _} -> pos end))

          {neighbours, new_grid}

          {
            {neighbours, count},
            new_grid
          }
        else
          {nil, acc_grid}
        end
      end)

    result
    |> Enum.filter(&(&1 != nil))
    |> IO.inspect()
    |> Enum.reduce(0, fn {region, perimiter}, acc -> length(region) * perimiter + acc end)
    |> IO.inspect(label: "result")
  end

  def part2(input) do
    %Grid{grid: grid} = Grid.from_input(input)

    {result, _} =
      Enum.map_reduce(grid, grid, fn {pos, val}, acc_grid ->
        if Map.has_key?(acc_grid, pos) do
          {new_grid, {neighbours, count}} =
            find_neighbours({acc_grid, {[], 0}}, {pos, val})

          new_grid =
            Map.drop(new_grid, Enum.map(neighbours, fn {pos, _} -> pos end))

          {neighbours, new_grid}

          {
            {neighbours, count},
            new_grid
          }
        else
          {nil, acc_grid}
        end
      end)

    result
    |> Enum.filter(&(&1 != nil))
    |> Enum.reduce(0, fn {region, perimiter}, acc -> length(region) * perimiter + acc end)
    |> IO.inspect(label: "result")
  end

  def find_neighbours({grid, {acc, count}}, {position, value} = cell) when is_map(grid) do
    IO.inspect({cell, grid}, label: "find for cell")

    grid =
      Map.update(grid, position, :not_found, fn x ->
        case x do
          {_, :visited} ->
            x

          _ ->
            {x, :visited}
        end
      end)

    all_neighbours =
      Grid.adjacent_cells(grid, position, :cardinal, false)

    perimiter = perimiter(all_neighbours, value)

    IO.inspect(perimiter, label: "Perimiter")

    true_neighbours =
      Enum.filter(all_neighbours, fn {_pos, val} -> val == value && not is_tuple(val) end)
      |> IO.inspect(label: "True n")

    find_neighbours({grid, {[cell | acc], count + length(perimiter)}}, true_neighbours)
  end

  def find_neighbours({grid, acc}, []) do
    {grid, acc} |> IO.inspect(label: "Final")
  end

  def find_neighbours({grid, acc}, [{pos, _val} = h | t]) do
    grid =
      Map.update(grid, pos, :not_found, fn x ->
        {x, :visited}
      end)

    find_neighbours(find_neighbours({grid, acc}, t), h) |> IO.inspect(label: "Recur")
  end

  def perimiter(neighbours, value) do
    Enum.filter(neighbours, fn {pos, val} ->
      IO.inspect({pos, val, value}, label: "Perimiter filter")
      val == nil || (val != value && not is_tuple(val))
    end)
  end
end
