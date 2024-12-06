defmodule Aoc2024.Day05 do
  def part1(args) do
    [rules, updates] =
      String.split(args, "\n\n") |> Enum.map(&String.split(&1, "\n", trim: true))

    rules =
      Enum.map(rules, fn rule -> String.split(rule, "|") |> List.to_tuple() end)
      |> Enum.reduce(%{}, fn rule, acc ->
        parse(rule, acc)
      end)

    updates = Enum.map(updates, fn update -> String.split(update, ",") end)

    Enum.map(
      updates,
      &{read_forward(&1, rules) |> List.flatten() |> Enum.count(fn x -> x == :invalid end), &1}
    )
    |> Enum.filter(fn {invalid_count, _list} -> invalid_count == 0 end)
    |> Enum.map(fn {_, list} ->
      Enum.at(
        list,
        if length(list) == 1 do
          1
        else
          floor(length(list) / 2)
        end
      )
    end)
    |> Enum.reduce(0, fn page, acc -> String.to_integer(page) + acc end)
  end

  def part2(args) do
  end

  def read_forward([_page | []], _) do
    :valid
  end

  def read_forward([page | t], rule_set) do
    page_rules = Map.get(rule_set, page)
    [check_membership(t, page, page_rules), read_forward(t, rule_set)]
  end

  def check_membership([], _page, _page_rules) do
    [:valid]
  end

  def check_membership(_, _, nil) do
    [:valid]
  end

  def check_membership(h, _page, page_rules) when is_binary(h) do
    if MapSet.member?(page_rules, h) do
      [:invalid]
    else
      [:valid]
    end
  end

  def check_membership([h | t], page, page_rules) do
    [check_membership(h, page, page_rules) | check_membership(t, page, page_rules)]
  end

  def parse({first, second}, map \\ %{}) do
    {_, new_map} =
      Map.get_and_update(map, second, fn current ->
        {current,
         case current do
           nil -> MapSet.new() |> MapSet.put(first)
           _ -> MapSet.put(current, first)
         end}
      end)

    new_map |> IO.inspect(label: :new_map)
  end
end
