defmodule Elixir.Mix.Tasks.D05.P1 do
  use Mix.Task

  alias Aoc2024.Day05
  import Elixir.Aoc2024.Day05

  @shortdoc "Day 5 Part 1"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(5)
    Day05.part1(input) |> IO.inspect(label: "Result Day 5 part 1")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1() end}),
      else:
        input
        |> part1()
        |> IO.inspect(label: "Part 1 Results")
  end
end
