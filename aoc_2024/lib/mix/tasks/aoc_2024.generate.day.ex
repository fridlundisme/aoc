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

    full_day = String.pad_leading(to_string(day), 2, "0")
    day_module_name = Igniter.Project.Module.parse("Aoc2024.Day#{full_day}")
    test_module_name = Igniter.Project.Module.parse("Aoc2024.Day#{full_day}Test")

    # Do your work here and return an updated igniter
    igniter
    |> Igniter.assign(
      year: 2024,
      day: day,
      full_day: full_day,
      day_module_name: day_module_name
    )
    |> Igniter.Project.Module.create_module(day_module_name, """
    def part1(args) do
    end

    def part2(args) do

    end
    """)
    |> add_mix_task(1)
    |> add_mix_task(2)
    |> Igniter.Project.Module.create_module(
      test_module_name,
      """
        use ExUnit.Case

        import #{day_module_name}

        def input do
          ~S""
        end

        @tag :skip
        test "part1" do
          result = part1(input())

          assert result == nil
        end

        @tag :skip
        test "part2" do
          result = part2(input())

          assert result == nil
          end
      """,
      path: Igniter.Project.Module.proper_location(igniter, test_module_name, :test)
    )
  end

  defp add_mix_task(igniter, part) do
    template_path = Path.expand("templates/day_mix_task.heex")

    part_module_name =
      Igniter.Project.Module.parse("Mix.Tasks.D#{igniter.assigns[:full_day]}.P#{part}")

    assigns =
      Keyword.merge(
        Map.to_list(igniter.assigns),
        part: part,
        module_name: part_module_name
      )

    Igniter.copy_template(
      igniter,
      template_path,
      Igniter.Project.Module.proper_location(igniter, part_module_name),
      assigns
    )
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
