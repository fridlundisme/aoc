defmodule Grid do
  alias __MODULE__, as: T

  @type t(a) :: %T{
          grid: grid(a),
          width: non_neg_integer,
          height: non_neg_integer
        }

  @enforce_keys ~w[grid width height]a
  defstruct @enforce_keys

  @type t :: t(term)

  @typep grid(a) :: %{coordinates => a}

  @type coordinates :: {non_neg_integer, non_neg_integer}

  # List of coords that produce the 4 coordinates horizontally/vertically adjacent to a given coord when added to it
  @cardinal_adjacent_deltas for x <- -1..1, y <- -1..1, abs(x) + abs(y) == 1, do: {x, y}
  @diagonal_adjacent_deltas_anti [{-1, 1}, {1, -1}]
  @diagonal_adjacent_deltas_main [{1, 1}, {-1, -1}]
  @diagonal_adjacent_deltas @diagonal_adjacent_deltas_main ++ @diagonal_adjacent_deltas_anti

  @directions_by_type %{
    nw: {-1, -1},
    ne: {1, -1},
    n: {0, -1},
    w: {-1, 0},
    e: {1, 0},
    s: {0, 1},
    se: {1, 1},
    sw: {-1, 1}
  }

  def from_input(input, mapper \\ &Function.identity/1, char_type \\ &String.codepoints/1) do
    charlists =
      input
      |> String.split()
      |> Enum.map(char_type)

    height = length(charlists)
    width = length(hd(charlists))

    grid =
      for {line, y} <- Enum.with_index(charlists),
          {char, x} <- Enum.with_index(line),
          into: %{} do
        {{x, y}, mapper.(char)}
      end

    %T{
      grid: grid,
      width: width,
      height: height
    }
  end

  def adjacent_cells(grid, cell, directions \\ :all)

  def adjacent_cells(grid, cell, :all) do
    Enum.concat(
      adjacent_cells(grid, cell, :cardinal),
      adjacent_cells(grid, cell, :diagonal)
    )
  end

  def adjacent_cells(grid, cell, :cardinal) do
    @cardinal_adjacent_deltas
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} -> is_nil(val) end)
  end

  def adjacent_cells(grid, cell, :diagonal_main) do
    @diagonal_adjacent_deltas_main
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} -> is_nil(val) end)
  end

  def adjacent_cells(grid, cell, :diagonal_anti) do
    @diagonal_adjacent_deltas_anti
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} -> is_nil(val) end)
  end

  def adjacent_cells(grid, cell, :diagonal) do
    @diagonal_adjacent_deltas
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} -> is_nil(val) end)
  end

  # To implement
  # def find(grid, to_find) when is_list(to_find) do
  #   to_find
  # end

  def find(grid, to_find) when is_binary(to_find) do
    Map.filter(grid, fn {_key, val} -> val == to_find end)
  end

  def move(grid, from, direction) do
    new_coordinates(from, @directions_by_type[direction])
    |> then(fn coord -> {coord, Map.get(grid, coord)} end)
  end

  def rotate(direction) do
    case direction do
      :n -> :e
      :w -> :n
      :e -> :s
      :s -> :w
      _ -> :error
    end
  end

  defp new_coordinates({x1, x2}, {y1, y2}) do
    {x1 + y1, x2 + y2}
  end
end
