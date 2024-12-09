defmodule Aoc2024.Day06 do
  def part1(input) do
    %Grid{grid: grid} = Grid.from_input(input)

    starting_coordinates =
      Regex.run(~r/\^/, input)
      |> List.to_string()
      |> then(&(Grid.find(grid, &1) |> Map.keys() |> Enum.at(0)))

    start_moving(grid, starting_coordinates)
    |> Map.values()
    |> IO.inspect()
    |> Enum.count(fn val ->
      case val do
        {"X", _} -> true
        _ -> false
      end
    end)
  end

  def part2(input) do
  end

  # Start moving North
  def start_moving(grid, starting_coordinates, starting_direction \\ :n) do
    grid = Map.update!(grid, starting_coordinates, fn _ -> "X" end)

    {new_coord, char} =
      Grid.move(grid, starting_coordinates, starting_direction)

    move(grid, lookahead(starting_direction, char), starting_coordinates, new_coord)
  end

  def move(grid, :done, position, _) do
    mark_visited(grid, position, Map.get(grid, position))
  end

  def move(grid, {:rotate, new_dir}, position, _) do
    {new_coord, char} = Grid.move(grid, position, new_dir)
    move(grid, lookahead(new_dir, char), position, new_coord)
  end

  def move(grid, {:cont, new_dir}, position, new_position) do
    grid = mark_visited(grid, position, Map.get(grid, position))
    {new_coord, char} = Grid.move(grid, new_position, new_dir)
    move(grid, lookahead(new_dir, char), new_position, new_coord)
  end

  def lookahead(current_direction, char) do
    case char do
      nil -> :done
      "#" -> {:rotate, Grid.rotate(current_direction)}
      _ -> {:cont, current_direction}
    end
  end

  def mark_visited(grid, position, {"X", _}) do
    Map.update!(grid, position, fn {val, count} -> {val, count + 1} end)
  end

  def mark_visited(grid, position, char) do
    Map.update!(grid, position, fn _ -> {"X", 1} end)
  end
end
