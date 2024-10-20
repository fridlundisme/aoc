defmodule Solution do
  def read_file(file) do
    String.split(file, "\n") |> read_lines() |> IO.puts()
  end

  def read_lines(lines, acc \\ 0)

  def read_lines([], acc) do
    acc
  end

  def read_lines([h | t], acc) do
    val =
      String.split(h, ",")
      |> overlap?()

    val + read_lines(t, acc)
  end

  def overlap?(x) do
    ls =
      Enum.fetch!(x, 0) |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

    rs =
      Enum.fetch!(x, 1) |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()

    compare(ls, rs)
  end

  def compare({ls_low, _ls_high}, {rs_low, _rs_high}) when ls_low == rs_low, do: 1
  def compare({_ls_low, ls_high}, {_rs_low, rs_high}) when ls_high == rs_high, do: 1

  def compare({ls_low, ls_high}, {rs_low, rs_high}) when ls_low > rs_low do
    result =
      cond do
        ls_low <= rs_high && rs_high <= ls_high ->
          1

        rs_low <= ls_high && ls_high <= rs_high ->
          1

        true ->
          IO.inspect("#{ls_low} #{ls_high} #{rs_low} #{rs_high}", label: "first")
          0
      end

    result
  end

  def compare({ls_low, ls_high}, {rs_low, rs_high}) do
    result =
      cond do
        rs_low <= ls_high && ls_high <= rs_high ->
          1

        ls_low <= rs_high && rs_high <= ls_high ->
          1

        true ->
          IO.inspect("#{ls_low} #{ls_high} #{rs_low} #{rs_high}", label: "second")
          0
      end

    result
  end
end

Helpers.Parsing.read_file() |> Solution.read_file()
