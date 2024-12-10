defmodule Elixir.Mix.Tasks.D04.P1 do
  use Mix.Task

  import Elixir.Aoc2024.Day04

  @shortdoc "Day 4 Part 1"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(4)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
