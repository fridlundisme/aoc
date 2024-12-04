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

  @directions_by_type %{
    n: {-1, 0},
    w: {0, -1},
    e: {0, 1},
    s: {1, 0}
  }

  def from_input(input, mapper \\ &Function.identity/1, char_type \\ &String.codepoints/1) do
    charlists =
      input
      |> String.split()
      |> Enum.map(char_type)

    height = length(charlists)
    width = length(hd(charlists))

    grid =
      for {line, x} <- Enum.with_index(charlists),
          {char, y} <- Enum.with_index(line),
          into: %{} do
        {{x, y}, mapper.(char)}
      end

    %T{
      grid: grid,
      width: width,
      height: height
    }
  end

  def adjacent_cells(grid, cell) do
    @cardinal_adjacent_deltas
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} -> is_nil(val) end)
  end

  def move(grid, from, direction) do
    new_coordinates(from, @directions_by_type[direction])
    |> then(fn coord -> {coord, Map.get(grid, coord)} end)
  end

  defp new_coordinates({x1, x2}, {y1, y2}) do
    {x1 + y1, x2 + y2}
  end
end
