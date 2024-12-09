defmodule Aoc2024.Day05 do
  def part1(args) do
    [rules, updates] =
      String.split(args, "\n\n") |> Enum.map(&String.split(&1, "\n", trim: true))

    {_rules, updates} = get_all(rules, updates, :set)

    updates
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
    [rules, updates] =
      String.split(args, "\n\n") |> Enum.map(&String.split(&1, "\n", trim: true))

    {rules, updates} = get_all(rules, updates, :array)

    updates
    |> Enum.filter(fn {invalid_count, _list} -> invalid_count > 0 end)
    |> Enum.map(fn {_, update} -> update end)
    |> Enum.map(
      &Enum.sort(
        &1,
        fn a, b ->
          get_comparable(rules, a) < get_comparable(rules, b)
        end
      )
    )
    |> IO.inspect(label: :updates)
    |> Enum.map(
      &Enum.at(
        &1,
        if length(&1) == 1 do
          1
        else
          floor(length(&1) / 2)
        end
      )
    )
    |> Enum.reduce(0, fn page, acc -> String.to_integer(page) + acc end)
  end

  def get_comparable(rules, value) do
    Map.get(rules, value)
    |> case do
      nil -> 0
      list -> length(list)
    end
  end

  def sort_order(prio_map, current)

  def sort_order(prio_map, current) do
    prio_map = Map.delete(prio_map, current)
    Map.update(prio_map, :result, [current], fn existing -> [current | existing] end)
  end

  def get_all(rules, updates, list_type) do
    rules =
      Enum.map(rules, fn rule -> String.split(rule, "|") |> List.to_tuple() end)
      |> Enum.reduce(%{}, fn rule, acc ->
        parse(rule, list_type, acc)
      end)

    updates = Enum.map(updates, fn update -> String.split(update, ",") end)

    updates =
      Enum.map(
        updates,
        &{read_forward(&1, rules) |> List.flatten() |> Enum.count(fn x -> x == :invalid end), &1}
      )

    {rules, updates}
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
    if Enum.member?(page_rules, h) do
      [:invalid]
    else
      [:valid]
    end
  end

  def check_membership([h | t], page, page_rules) do
    [check_membership(h, page, page_rules) | check_membership(t, page, page_rules)]
  end

  def parse({first, second}, list_type, map \\ %{}) do
    case list_type do
      :set ->
        Map.update(map, second, MapSet.new([first]), fn current -> MapSet.put(current, first) end)

      :array ->
        Map.update(map, second, [first], fn current -> [first | current] end)
    end
  end
end
