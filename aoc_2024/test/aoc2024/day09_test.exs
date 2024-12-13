defmodule Aoc2024.Day09Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day09

  def input do
    ~S"2333133121414131402"
  end

  test "part1" do
    result = part1(input())
    assert result == 1928
  end

  @tag :skip
  test "part2" do
    result = part2(input())

    assert result == nil
  end
end
