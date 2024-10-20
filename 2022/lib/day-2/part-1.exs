defmodule RockPaperScissors do
  def read_lines(file) do
    split_file = String.split(file, "\n")
    play(split_file) |> IO.inspect()
  end

  def play([match | rest]) do
    hands = String.split(match) |> IO.inspect()
    opponent = Enum.fetch!(hands, 0) |> IO.inspect()
    you = Enum.fetch!(hands, 1)
    (result({opponent, you}) |> elem(1)) + play(rest)
  end

  def play([]) do
    0
  end

  def result({opponent, you}) do
    result_map(you)[opponent]
  end

  def result_map(you) do
    cond do
      you == "X" -> %{"C" => {:win, 7}, "B" => {:loss, 1}, "A" => {:draw, 4}}
      you == "Y" -> %{"A" => {:win, 8}, "C" => {:loss, 2}, "B" => {:draw, 5}}
      you == "Z" -> %{"B" => {:win, 9}, "A" => {:loss, 3}, "C" => {:draw, 6}}
    end
  end
end

Helpers.Parsing.read_file() |> RockPaperScissors.read_lines()
