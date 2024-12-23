defmodule Elixir.Mix.Tasks.D13.P1 do
  use Mix.Task

  import Elixir.Aoc2024.Day13

  @shortdoc "Day 13 Part 1"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(13)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end