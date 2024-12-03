defmodule Elixir.Mix.Tasks.D03.P1 do
  use Mix.Task

  alias Aoc2024.Day03
  import Elixir.Aoc2024.Day03

  @shortdoc "Day 3 Part 1"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(3)
    Day03.part1(input) |> IO.inspect(label: "Result Day 3 part 1")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
