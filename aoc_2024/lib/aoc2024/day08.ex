defmodule Aoc2024.Day08 do
  def part1(input) do
    %Grid{grid: grid, width: width, height: height} = Grid.from_input(input)
    antennas = Grid.find(grid, ~r/[0-9A-Za-z]/, :regex)

    Enum.map(antennas, fn {p, freq} -> {freq, p} end)
    |> Enum.group_by(
      fn {freq, _} -> freq end,
      fn {_freq, p} -> p end
    )
    |> Enum.flat_map(fn {_freq, positions} ->
      Enum.map(positions, fn p ->
        {p,
         get_antinodes(p, Enum.filter(positions, &(&1 != p)))
         |> Enum.map(fn diff -> Grid.new_coordinates(p, diff) end)}
      end)
      |> Enum.flat_map(fn {_, antinodes} ->
        antinodes
      end)
    end)
    |> Enum.filter(fn antinode ->
      Grid.fits_in_grid?({width, height}, antinode)
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(input) do
    %Grid{grid: grid, width: width, height: height} = Grid.from_input(input)
    antennas = Grid.find(grid, ~r/[0-9A-Za-z]/, :regex)

    Enum.map(antennas, fn {p, freq} -> {freq, p} end)
    |> Enum.group_by(
      fn {freq, _} -> freq end,
      fn {_freq, p} -> p end
    )
    |> Enum.flat_map(fn {_freq, positions} ->
      Enum.map(positions, fn p ->
        {p, get_antinodes(p, Enum.filter(positions, &(&1 != p)))}
      end)
      |> Enum.flat_map(fn {antenna, antinodes} ->
        Enum.flat_map(antinodes, fn {x, y} = antinode ->
          [scale(antenna, antinode, {width, height}) | scale(antenna, {-x, -y}, {width, height})]
        end)
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def scale(antenna, scaler, grid_size, acc \\ []) do
    with new_node <- Grid.new_coordinates(antenna, scaler) do
      if Grid.fits_in_grid?(grid_size, new_node) do
        scale(new_node, scaler, grid_size, [new_node | acc])
      else
        acc
      end
    end
  end

  def get_antinodes(p, list, acc \\ [])

  def get_antinodes(p, val, acc) when is_tuple(val) do
    [
      Grid.diff_vector(val, p)
      | acc
    ]
  end

  def get_antinodes(p, [h | []], acc) do
    get_antinodes(p, h, acc)
  end

  def get_antinodes(p, [h | t], acc) do
    get_antinodes(p, t, get_antinodes(p, h, acc))
  end
end
