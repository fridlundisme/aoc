defmodule Aoc2024.Day04Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day04

  def input do
    ~S"MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"
  end

  @tag :skip
  test "part1" do
    result = part1(input())

    assert result == 18
  end

  test "part2" do
    result = part2(input())

    assert result == 9
  end
end
