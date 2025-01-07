defmodule Aoc2024.Day14 do
  @iterations 2000
  # Refault values W: 101, H: 103
  def part1(input, {w, h} = grid_size \\ {101, 103}) do
    robot_specs =
      get_pos_vel(input)

    frequencies = frequencies(robot_specs, grid_size, @iterations)
    quadrants = quadrants(w, h)

    Enum.reduce(quadrants, 1, fn q, acc ->
      with filtered = Map.filter(frequencies, fn {key, _} -> Enum.member?(q, key) end) do
        q_values = Map.values(filtered) |> Enum.sum()
        q_values * acc
      end
    end)
  end

  def part2(input, {w, h} = grid_size \\ {101, 103}) do
    robot_specs =
      get_pos_vel(input)

    Task.async_stream(
      5600..10000,
      fn i ->
        Grid.create_grid(w, h, 0, 0, ".")
        |> Map.merge(frequencies(robot_specs, grid_size, i))
        |> then(
          &Grid.print(%Grid{grid: &1, width: w, height: h}, ~r/[0-9]+/,
            write: true,
            path: Path.join([File.cwd!(), "lib/aoc2024/tmp/results_#{i}.txt"])
          )
        )
      end
    )
    |> Enum.with_index()
    |> Enum.group_by(fn {file, _index} -> file end, fn {_file, index} -> index end)
    |> Enum.filter(fn {_file, indices} -> length(indices) > 1 end)
  end

  def part_2_group() do
    Path.wildcard(Path.join([File.cwd!(), "lib/aoc2024/tmp/*"]))
    |> Enum.map(&File.read!(&1))
    |> Enum.with_index()
    |> Enum.group_by(fn {file, _index} -> file end, fn {_file, index} -> index end)
    |> Enum.filter(fn {_file, indices} -> length(indices) > 1 end)
  end

  def simulate(grid, {pos, _}, 0, _grid_size) do
    pos
  end

  def simulate(grid, {starting_pos, velocity}, seconds, grid_size) do
    with new_pos = Grid.new_coordinates(starting_pos, velocity) do
      if Grid.fits_in_grid?(grid_size, new_pos) do
        Map.put(grid, new_pos, velocity)
        |> simulate({new_pos, velocity}, seconds - 1, grid_size)
      else
        Map.put(grid, wrap_around(new_pos, grid_size), velocity)
        |> simulate({wrap_around(new_pos, grid_size), velocity}, seconds - 1, grid_size)
      end
    end
  end

  defp wrap_around({x, y}, {w, h}) do
    x =
      if x < 0 || x >= w do
        Integer.mod(x, w)
      else
        x
      end

    y =
      if y < 0 || y >= h do
        Integer.mod(y, h)
      else
        y
      end

    {x, y}
  end

  defp quadrants(w, h) do
    q4 =
      Grid.create_grid(w, h, round((w - 1) / 2) + 1, round((h - 1) / 2) + 1)
      |> Map.keys()

    q1 =
      Grid.create_grid(round((w - 1) / 2) - 1, round((h - 1) / 2) - 1)
      |> Map.keys()

    q3 = Grid.create_grid(round((w - 1) / 2) - 1, h, 0, round((h - 1) / 2) + 1) |> Map.keys()
    q2 = Grid.create_grid(w, round((h - 1) / 2) - 1, round((w - 1) / 2) + 1) |> Map.keys()
    [q1, q2, q3, q4]
  end

  defp get_pos_vel(input) do
    String.split(input, "\n", trim: true)
    |> Enum.map(fn row ->
      re_p = ~r/p\=(\-?[0-9]+),(\-?[0-9]+)/
      re_v = ~r/v\=(\-?[0-9]+),(\-?[0-9]+)/
      [_, p_x, p_y] = Regex.run(re_p, row)
      [_, v_x, v_y] = Regex.run(re_v, row)
      [p_x, p_y, v_x, v_y] = Enum.map([p_x, p_y, v_x, v_y], &String.to_integer/1)
      [p: {p_x, p_y}, v: {v_x, v_y}]
    end)
  end

  defp frequencies(robot_specs, {w, h} = grid_size, iterations) do
    Enum.reduce(robot_specs, [], fn [{:p, p}, {:v, v}], acc ->
      robot = {p, v}

      [
        simulate(%{}, robot, iterations, grid_size)
        | acc
      ]
    end)
    |> Enum.filter(fn {x, y} ->
      cond do
        x == round((w - 1) / 2) -> false
        y == round((h - 1) / 2) -> false
        true -> true
      end
    end)
    |> Enum.frequencies()
  end

  def te() do
  end

  def christmas_formation({grid, w, h}) do
    vertical_middle = round((w - 1) / 2)
    horizontal_middle = round((h - 1) / 2)
    starting_pos = {vertical_middle, 0}

    Enum.map([{vertical_middle, 0}, {vertical_middle, horizontal_middle}], fn {x, y} = pos ->
      move(grid, pos)
    end)
  end

  def move(grid, pos, acc \\ [])

  def move(_grid, nil, acc) do
    acc
  end

  def move(grid, pos, acc) do
    case Grid.next(grid, pos, :sw) do
      {:error, val} ->
        [pos | acc]

      {new_pos, val} ->
        [pos | move(grid, new_pos, acc)]
    end
  end
end
