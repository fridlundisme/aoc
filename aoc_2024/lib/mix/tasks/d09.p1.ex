defmodule Elixir.Mix.Tasks.D09.P1 do
  use Mix.Task

  alias Aoc2024.Day09
  import Elixir.Aoc2024.Day09

  @shortdoc "Day 9 Part 1"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(9)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
