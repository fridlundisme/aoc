defmodule Aoc2024.Day11Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day11

  @doc """
  Every time you blink, the stones each simultaneously change according to the first applicable rule in this list
  - number: 0, replace with: 1.
  - length(number) %2 == true, replace with: two stones.
  - - [l{n/2} | r{n/2}] two new stones
  - - l{n/2} & r{n/2}
  - - (The new numbers don't keep extra leading zeroes: 1000 would become stones 10 and 0.)
  - ELSE
  - - number * 2024 is engraved on the new stone.

  """
  def input do
    ~S"125 17"
  end

  test "part1" do
    result = part1(input())

    assert result == 55312
  end

  @tag :skip
  test "part2" do
    result = part2(input())

    assert result == nil
  end
end
