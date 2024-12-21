defmodule Aoc2024.Day12Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day12

  def input0 do
    ~S"AAAA"
  end

  def input1 do
    ~S"AAAA
    BBCD
    BBCC
    EEEC"
  end

  def input2 do
    ~S"OOOOO
    OXOXO
    OOOOO
    OXOXO
    OOOOO"
  end

  def input3 do
    ~S"RRRRIICCFF
    RRRRIICCCF
    VVRRRCCFFF
    VVRCCCJFFF
    VVVVCJJCFE
    VVIVCCJJEE
    VVIIICJJEE
    MIIIIIJJEE
    MIIISIJEEE
    MMMISSJEEE"
  end

  test "part1" do
    result1 = part1(input1())
    # result2 = part1(input2())
    # result3 = part1(input3())

    assert result1 == 140
    # assert result2 == 772
    # assert result3 == 1930
  end

  @tag :skip
  test "part2" do
    result1 = part2(input1())
    result2 = part2(input2())
    result2 = part2(input3())

    assert result1 == 80
    assert result2 == 436
  end
end
