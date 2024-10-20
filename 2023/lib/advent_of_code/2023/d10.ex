defmodule AdventOfCode.Year2023.Day10 do
  alias AdventOfCode.Grid, as: Grid

  def ex_input() do
    ".....
.S-7.
.|.|.
.L-J.
....."
  end

  def read_lines(input) do
    case input do
      :real ->
        File.read!("priv/input/d10.txt")

      :ex ->
        ex_input()

      _ ->
        nil
    end
  end

  @pipes %{
    ?- => [:w, :e],
    ?| => [:n, :s],
    ?7 => [:s, :w],
    ?J => [:n, :w],
    ?L => [:n, :e],
    ?F => [:s, :e]
  }
  def p1 do
    %Grid{:grid => grid} = Grid.from_input(read_lines(:ex))

    {s_coor, s_val} =
      grid
      |> find_s()

    start = {s_coor, s_val}

    play(start, grid)
  end

  defp play({from_coor, _from_val}, grid) do
    {to_coor, to_dir} =
      Grid.adjacent_cells(grid, from_coor)
      |> Enum.map(fn {coor, val} -> {coor, Map.get(@pipes, val)} end)
      |> Enum.reject(fn {_coor, val} -> is_nil(val) end)
      |> Enum.at(0)

    val = Map.get(grid, to_coor)
    IO.inspect({to_coor, <<val::utf8>>})

    move(from_coor, {to_coor, to_dir, val}, grid)
  end

  defp move(_from, {_coor, _dir, ?S}, _grid, count) do
    count + 1
  end

  defp move(_from, {_coor, _dir, _}, _grid, 2) do
  end

  defp move(from_coor, {to_coor, to_directions, to_val}, grid, count \\ 0) do
    IO.inspect({from_coor, to_coor, <<to_val::utf8>>}, label: "from -> to")

    {from_dir, _} =
      Grid.moving_from_direction(from_coor, to_coor) |> IO.inspect(label: :from_dir)

    [to_dir | _] =
      Enum.reject(to_directions, &match?(^from_dir, &1))
      |> IO.inspect(label: "to_dir")

    {new, new_val} = Grid.move(grid, to_coor, to_dir)
    IO.inspect(new, label: "new")

    move(to_coor, {new, new_dir, new_val}, grid, count + 1)
  end

  defp find_s(grid) do
    Enum.find(grid, fn {_coor, val} ->
      match?(^val, ?S)
    end)
  end
end
