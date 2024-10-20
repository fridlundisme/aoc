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
      |> is_fully_contained?()

    val + read_lines(t, acc)
  end

  def is_fully_contained?(x) do
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
        rs_high >= ls_high -> 1
        true -> 0
      end

    result
  end

  def compare({_ls_low, ls_high}, {_rs_low, rs_high}) do
    result =
      cond do
        ls_high >= rs_high -> 1
        true -> 0
      end

    result
  end
end

Helpers.Parsing.read_file() |> Solution.read_file()
