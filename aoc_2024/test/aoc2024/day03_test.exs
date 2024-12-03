defmodule Aoc2024.Day03Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day03

  def input do
    ~S"xmul(2,4)&mul(3,7)!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  end

  @tag :skip
  test "part1" do
    result = part1(input())

    assert result == 161
  end

  test "part2" do
    result = part2(input())

    assert result == 48
  end
end
