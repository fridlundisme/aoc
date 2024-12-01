defmodule Elixir.Mix.Tasks.D01.P1 do
  alias Aoc2024.Day01
  use Mix.Task

  import Elixir.Aoc2024.Day01

  @shortdoc "Day 1 Part 1"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(1)
    Day01.part1(input) |> IO.inspect(label: "Result")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
