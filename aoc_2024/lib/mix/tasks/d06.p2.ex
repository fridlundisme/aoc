defmodule Elixir.Mix.Tasks.D06.P2 do
  use Mix.Task

  import Elixir.Aoc2024.Day06

  @shortdoc "Day 6 Part 2"
  def run(args) do
    Mix.Task.run("app.start")
    input = Aoc2024.Input.get!(6)

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
