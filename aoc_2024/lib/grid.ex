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

  def create_grid(line_width, line_height, starting_x \\ 0, starting_y \\ 0, char \\ nil) do
    for y <- starting_y..line_height,
        x <- starting_x..line_width,
        into: %{} do
      {{x, y}, char}
    end
  end

  def from_input(input, opts \\ []) do
    char_type = if _char_type = opts[:char_type], do: opts[:char_type], else: &String.codepoints/1
    mapper = if _mapper = opts[:mapper], do: opts[:mapper], else: &Function.identity/1

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

  def get_col(grid, x_prime) do
    Map.filter(grid, fn {{x1, _y1}, _} -> x1 == x_prime end)
    |> Map.to_list()
    |> Enum.sort(fn {{_, y}, _}, {{_, y_2}, _} -> y < y_2 end)
    |> Enum.map(fn {_, val} -> val end)
  end

  def get_row(grid, y_prime) do
    Map.filter(grid, fn {{_x1, y1}, _} -> y1 == y_prime end)
    |> Map.to_list()
    |> Enum.sort(fn {{x, _}, _}, {{x_2, _}, _} -> x < x_2 end)
    |> Enum.map(fn {_, val} -> val end)
  end

  def mark_cells(grid, cells, mark) when is_list(cells) do
    Enum.reduce(cells, grid, fn {pos, _}, acc_grid ->
      Map.update(acc_grid, pos, :out, fn val -> {val, mark} end)
    end)
  end

  def mark_cells(grid, {pos, _}, mark) do
    Map.update!(grid, pos, fn val -> {val, mark} end)
  end

  def adjacent_cells(grid, cell, directions \\ :all, filter_nil \\ true)

  def adjacent_cells(grid, cell, :all, filter_nil) do
    Enum.concat(
      adjacent_cells(grid, cell, :cardinal, filter_nil),
      adjacent_cells(grid, cell, :diagonal, filter_nil)
    )
  end

  def adjacent_cells(grid, cell, :cardinal, filter_nil) do
    @cardinal_adjacent_deltas
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} ->
      if filter_nil do
        is_nil(val)
      else
        false
      end
    end)
  end

  def adjacent_cells(grid, cell, :diagonal_main, filter_nil) do
    @diagonal_adjacent_deltas_main
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} ->
      if filter_nil do
        is_nil(val)
      else
        false
      end
    end)
  end

  def adjacent_cells(grid, cell, :diagonal_anti, filter_nil) do
    @diagonal_adjacent_deltas_anti
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} ->
      if filter_nil do
        is_nil(val)
      else
        false
      end
    end)
  end

  def adjacent_cells(grid, cell, :diagonal, filter_nil) do
    @diagonal_adjacent_deltas
    |> Enum.map(&new_coordinates(&1, cell))
    |> Enum.map(fn coor -> {coor, Map.get(grid, coor)} end)
    |> Enum.reject(fn {_coords, val} ->
      if filter_nil do
        is_nil(val)
      else
        false
      end
    end)
  end

  def find(grid, to_find) do
    Map.filter(grid, fn {_key, val} -> val == to_find end)
  end

  def find(grid, regex, :regex) do
    Map.filter(grid, fn {_key, val} -> Regex.match?(regex, val) end)
  end

  def diff_vector({x1, y1}, {x2, y2}, vector_scaling \\ 1) do
    {(x2 - x1) * vector_scaling, (y2 - y1) * vector_scaling}
  end

  def fits_in_grid?({w, h}, {x, y}) do
    cond do
      x >= w || x < 0 -> false
      y >= h || y < 0 -> false
      true -> true
    end
  end

  def next(grid, from, direction) when is_atom(direction) do
    new_coord = new_coordinates(from, @directions_by_type[direction])

    case get_key(grid, new_coord) do
      {:error, coord} -> {:error, coord}
      {coord, val} -> {coord, val}
    end
  end

  # TODO What is the purpose here?
  # Move pos X -> Y
  # Return Map with value on new position.
  # Should it handle multiple? No use Enumerable instead
  def move(grid, from, direction, new_val \\ ".") do
    case next(grid, from, direction) do
      {:error, coord} ->
        {:error, {coord, nil}, grid}

      {coord, _} ->
        {old_coord, moving_val} = get_key(grid, from)

        IO.inspect({get_key(grid, from), {:new_val, new_val}}, label: "Grid.move")

        grid =
          Map.replace!(grid, coord, moving_val)
          |> Map.replace!(old_coord, new_val)

        {:ok, {coord, moving_val}, grid}
    end
  end

  defp get_key(grid, coord) do
    if Map.has_key?(grid, coord) do
      {coord, Map.get(grid, coord)}
    else
      {:error, coord}
    end
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

  def new_coordinates({x1, x2}, {y1, y2}) do
    {x1 + y1, x2 + y2}
  end

  def print(%Grid{grid: grid, width: w, height: h}, to_find \\ nil, to_file \\ [write: false]) do
    # Build a string for each row
    result =
      0..(h - 1)
      |> Enum.map(fn row ->
        0..(w - 1)
        |> Enum.map(fn col ->
          val = Map.get(grid, {col, row}, ".")

          if to_find do
            String.replace(to_string(val), to_find, "#")
          else
            Map.get(grid, {col, row}, ".")
          end
        end)
        |> Enum.join("")
      end)
      # Join all rows with a newline
      |> Enum.join("\n")

    IO.puts(result)

    if Keyword.get(to_file, :write, false) do
      file_path = Keyword.get(to_file, :path)

      case File.write(file_path, result) do
        :ok ->
          IO.puts("File written successfully to #{file_path}")
          result

        {:error, reason} ->
          IO.puts("Failed to write file: #{reason} #{file_path}")
          {:error, reason}
      end
    end
  end
end
