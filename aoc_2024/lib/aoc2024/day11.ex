defmodule Aoc2024.Day11 do
  def part1(input) do
    blink(input, 6)
  end

  def part2(input) do
    blink(input, 75)
  end

  def blink(input, count) do
    input =
      String.split(input)
      |> Enum.map(&String.to_integer/1)

    play({input, count})
    |> List.flatten()
    |> IO.inspect()
    |> Enum.count()
    |> IO.inspect(label: "result", charlists: :as_list)
  end

  defp parallel_map(list, func) do
    list
    |> Task.async_stream(func, timeout: :infinity)
    |> Enum.map(fn {:ok, result} -> result end)
  end

  def play({val, count}) when count <= 0 do
    val
  end

  def play({list, count}) when is_list(list) do
    Task.async_stream(list, &(play(rules(&1, count)) |> IO.inspect(label: "Play")),
      timeout: :infinity
    )
    |> Enum.map(fn {:ok, result} -> result end)
  end

  def play({list, count}) do
    rules(list, count) |> play
  end

  def rules(val, count) when count < 0 do
    {val, 0} |> IO.inspect(label: "< 0 rule")
  end

  def rules(0, count) when count < 2,
    do: {1, count - 1}

  def rules(0, count), do: {2024, count - 2}

  def rules(digit, iters) do
    digits = Integer.digits(digit)
    l = length(digits)

    {binary?, shift_amount} = binary_split?(digit, iters)

    IO.inspect({digit, binary?, iters, shift_amount}, label: "Rules")

    cond do
      l == 1 ->
        {digit * 2024, iters - 1}

      binary? ->
        play(
          {half_n_times(digits, shift_amount), iters - shift_amount}
          |> IO.inspect(label: "binary", charlists: :to_lists)
        )

      rem(l, 2) == 0 ->
        {Enum.chunk_every(digits, trunc(l / 2))
         |> Enum.map(&Integer.undigits/1), iters - 1}

      true ->
        {digit * 2024, iters - 1}
    end
  end

  def binary_split?(digit, count_togo) when digit > 99 do
    binary =
      digit
      |> Integer.digits()
      |> length()
      |> Integer.digits(2)

    is_power? =
      binary
      |> Enum.count(&(&1 == 1)) == 1

    max_shift_steps = Integer.undigits(binary, 2)

    min_shift_steps =
      count_togo |> Integer.digits(2) |> length()

    shift_steps =
      if(max_shift_steps > min_shift_steps) do
        min_shift_steps
      else
        max_shift_steps
      end

    {is_power?, shift_steps}
  end

  def binary_split?(_digit, _count) do
    {false, nil}
  end

  def half_n_times(list, n, acc \\ [])

  def half_n_times(list, n, acc) when n == 0 or is_integer(list) or length(list) < 2 do
    IO.inspect(list, label: " Here")

    [
      Enum.map(
        list,
        &if is_list(list) do
          Integer.undigits(&1)
        else
          &1
        end
      )
      | acc
    ]
  end

  def half_n_times([h, t], n, acc) when is_list(h) do
    half_n_times(h, n, half_n_times(t, n, acc))
  end

  def half_n_times(list, n, acc) when is_list(list) do
    half_n_times(Enum.chunk_every(list, trunc(length(list) / 2)), n - 1, acc)
  end
end
