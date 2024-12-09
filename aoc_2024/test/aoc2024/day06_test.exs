defmodule Aoc2024.Day06Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day06

  def input do
    ~S"
....#.....
.........#
..........
..#.......
.......#..
.........
.#..^.....
........#.
#.........
......#..."
  end

  @tag :skip
  test "part1" do
    result = part1(input())

    assert result == 41
  end

  test "part2" do
    result = part2(input())

    # assert result == 6
  end
end
