defmodule Aoc2024.Day08Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day08

  def input do
    ~S"
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............"
  end

  @tag :skip
  test "part1" do
    result = part1(input())

    assert result == 14
  end

  # @tag :skip
  test "part2" do
    result = part2(input())

    assert result == 34
  end
end
