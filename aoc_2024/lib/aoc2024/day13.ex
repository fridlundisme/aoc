defmodule Aoc2024.Day13 do
  def part1(input) do
    get_vectors(input)
    |> Enum.map(fn x ->
      {x_1, y_1} = Keyword.get(x, :a)
      {x_2, y_2} = Keyword.get(x, :b)
      {target_x, target_y} = Keyword.get(x, :target)

      {{target_x, target_y}, Nx.tensor([[x_1, x_2], [y_1, y_2]], type: :f64)}
    end)
    |> calculate()
    |> round()
  end

  def part2(input) do
    get_vectors(input)
    |> Enum.map(fn x ->
      {x_1, y_1} = Keyword.get(x, :a)
      {x_2, y_2} = Keyword.get(x, :b)
      {target_x, target_y} = Keyword.get(x, :target)

      {{target_x + 10_000_000_000_000, target_y + 10_000_000_000_000},
       Nx.tensor([[x_1, x_2], [y_1, y_2]], type: :f64)}
    end)
    |> calculate()
    |> round()
  end

  defp calculate(vectors) do
    vectors
    |> Enum.reduce(0, fn {target, result}, acc ->
      result_vector = Nx.tensor([elem(target, 0), elem(target, 1)], type: :f64)

      [a, b] =
        result
        |> Nx.LinAlg.solve(result_vector)
        |> Nx.to_list()

      if valid_precision?([a, b]) do
        acc + a * 3 + b
      else
        acc
      end
    end)
  end

  defp get_vectors(input) do
    String.split(input, "\n\n", trim: true)
    |> Enum.map(fn row ->
      [
        a: get_values(row, ~r/A\:.+X\+([0-9]+)/, ~r/A\:.+Y\+([0-9]+)/),
        b: get_values(row, ~r/B\:.+X\+([0-9]+)/, ~r/B\:.+Y\+([0-9]+)/),
        target: get_values(row, ~r/X\=([0-9]+)/, ~r/Y\=([0-9]+)/)
      ]
    end)
  end

  defp get_values(row, regex_x, regex_y) do
    {Enum.at(Regex.run(regex_x, row), 1) |> String.to_integer(),
     Enum.at(Regex.run(regex_y, row), 1) |> String.to_integer()}
  end

  defp valid_precision?(tensor, threshold \\ 0.01) do
    tensor
    # Convert tensor values to a list
    |> Enum.all?(fn value ->
      abs(value - Float.round(value)) <= threshold
    end)
  end
end
