defmodule Aoc2024.Day09 do
  alias Bitwise

  def part1(input) do
    String.codepoints(input)
    |> IO.inspect()
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
    |> Enum.reduce([], fn {val, index}, acc ->
      if rem(index, 2) == 0 do
        case index do
          0 ->
            [{nil, Integer.to_string(index) |> String.duplicate(val)} | acc]

          _ ->
            [
              {Bitwise.>>>(index, 1),
               Integer.to_string(Bitwise.>>>(index, 1)) |> String.duplicate(val)}
              | acc
            ]
        end
      else
        [{nil, "." |> String.duplicate(val)} | acc]
      end
    end)
    |> Enum.filter(fn {_, chars} -> chars != "" end)
    |> Enum.flat_map(fn {_, char} -> String.split(char, "", trim: true) end)
    |> Enum.reverse()
    |> IO.inspect(label: "with index")
    |> Enum.with_index()
    |> then(
      &Enum.map_reduce(&1, {0, length(&1) - 1}, fn {x, i}, {b, acc} ->
        IO.inspect({x, i, {b, acc}}, label: "first")

        if x == "." do
          {val, a} = get_val(&1, acc)
          {{{i, acc}, val}, {i, a}} |> IO.inspect(label: "get_val")
        else
          {{{i, acc}, x}, {i, acc}}
        end
      end)
    )
    |> then(fn {list, _} ->
      {list |> Enum.map(fn {_, val} -> val end),
       Enum.find_index(list, fn {{i, acc}, _val} -> i > acc end)}
    end)
    |> then(fn {list, size} -> Enum.take(list, size) end)
    |> IO.inspect()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {val, i}, acc ->
      with number <- Integer.parse(val) do
        case number do
          {val, _} -> val * i + acc
          :error -> acc
        end
      end
    end)
    |> IO.inspect()
  end

  def get_val(list, acc) do
    with {val, i} <- Enum.at(list, acc) do
      case val do
        "." -> get_val(list, acc - 1)
        _ -> {val, acc - 1}
      end
    end
  end

  def part2(args) do
  end
end
