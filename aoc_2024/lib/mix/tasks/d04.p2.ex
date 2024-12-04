defmodule Elixir.Mix.Tasks.D04.P2 do
  use Mix.Task

  alias Aoc2024.Day04
  import Elixir.Aoc2024.Day04

  @shortdoc "Day 4 Part 2"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(4)
    Day04.part2(input) |> IO.inspect(label: "Result Day 4 part 2")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
