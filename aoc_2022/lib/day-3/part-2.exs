defmodule Rugsack do
  def read_lines(file) do
    split_file = String.split(file, "\n")

    a_z = ?a..?z |> Enum.to_list()
    a_z_prio = 1..26 |> Enum.to_list()
    a_z_upper = ?A..?Z |> Enum.to_list()
    a_z_upper_prio = 27..52 |> Enum.to_list()
    map_1 = Enum.zip(a_z, a_z_prio) |> Enum.into(%{})
    map_2 = Enum.zip(a_z_upper, a_z_upper_prio) |> Enum.into(%{})
    full_map = Map.merge(map_1, map_2)

    chunked = Enum.chunk_every(split_file, 3)

    Stream.map(chunked, fn x -> line_priority(x, full_map) end)
    |> Enum.to_list()
    |> Enum.sum()
    |> IO.inspect(label: "part 2")
  end

  def line_priority(bags, priority_map) do
    Enum.map(bags, fn x -> to_charlist(x) end)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.map(fn x -> Map.get(priority_map, x, 0) end)
    |> Enum.sum()
  end
end

Helpers.Parsing.read_file() |> Rugsack.read_lines()
