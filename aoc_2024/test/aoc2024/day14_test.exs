defmodule Aoc2024.Day14Test do
  use ExUnit.Case

  import Elixir.Aoc2024.Day14

  def input do
    ~S"
    p=0,4 v=3,-3
    p=6,3 v=-1,-3
    p=10,3 v=-1,2
    p=2,0 v=2,-1
    p=0,0 v=1,3
    p=3,0 v=-2,-2
    p=7,6 v=-1,-3
    p=3,0 v=-1,-2
    p=9,3 v=2,3
    p=7,3 v=-1,2
    p=2,4 v=2,-3
    p=9,5 v=-3,-3"
  end

  def input0() do
    ~S"p=2,4 v=2,-3"
  end

  @tag :skip
  test "part1" do
    result = part1(input(), {11, 7})

    assert result == 12
  end

  test "part2" do
    result = part2(input(), {11, 7})

    # assert result == nil
  end
end
