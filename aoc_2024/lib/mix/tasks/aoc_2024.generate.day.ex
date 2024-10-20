defmodule Mix.Tasks.Aoc2024.Generate.Day do
  use Igniter.Mix.Task

  @example "mix aoc_2024.generate.day 24"

  @shortdoc "Generates scaffold for solutions in AOC 2024"
  @moduledoc """
  #{@shortdoc}

  Longer explanation of your task

  ## Example

  ```bash
  #{@example}
  ```

  ## Options

  * [day] The day of the month to generate. Defaults to todays date in CET.
  """

  def info(_argv, _composing_task) do
    %Igniter.Mix.Task.Info{
      # Groups allow for overlapping arguments for tasks by the same author
      # See the generators guide for more.
      group: :aoc_2024,
      # dependencies to add
      adds_deps: [],
      # dependencies to add and call their associated installers, if they exist
      installs: [],
      # An example invocation
      example: @example,
      # a list of positional arguments, i.e `[:file]`
      positional: [day: [optional: true]],
      # Other tasks your task composes using `Igniter.compose_task`, passing in the CLI argv
      # This ensures your option schema includes options from nested tasks
      composes: [],
      # `OptionParser` schema
      schema: [],
      # Default values for the options in the `schema`.
      defaults: [],
      # CLI aliases
      aliases: [],
      # A list of options in the schema that are required
      required: []
    }
  end

  def igniter(igniter, argv) do
    # extract positional arguments according to `positional` above
    {arguments, _argv} = positional_args!(argv)
    day = format_day(Map.get(arguments, :day))

    day = String.pad_leading(to_string(day), 2, "0")
    day_module_name = Igniter.Project.Module.parse("Aoc2024.Day#{day}")

    dbg({"day:", day_module_name})
    # Do your work here and return an updated igniter
    igniter
    |> Igniter.Project.Module.create_module(day_module_name, """
    def part1(args) do
    end

    def part2(args) do

    end
    """)
  end

  defp format_day(nil) do
    date = DateTime.now!("Europe/Stockholm")
    date.day
  end

  defp format_day(day) when is_binary(day) do
    case Integer.parse(day) do
      {day, _} when day in 1..25 ->
        day

      _ ->
        raise ArgumentError, "provide a date between 1 and 25"
    end
  end
end
