defmodule Elixir.Mix.Tasks.D05.P2 do
  use Mix.Task

  alias Aoc2024.Day05
  import Elixir.Aoc2024.Day05

  @shortdoc "Day 5 Part 2"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(5)
    Day05.part2(input) |> IO.inspect(label: "Result Day 5 part 2")

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
