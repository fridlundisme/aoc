defmodule RockPaperScissors do
  def read_lines(file) do
    split_file = String.split(file, "\n")
    play(split_file) |> IO.inspect()
  end

  def play([match | rest]) do
    hands = String.split(match)
    opponent = Enum.fetch!(hands, 0)
    you = Enum.fetch!(hands, 1)
    (result({opponent, you}) |> elem(1)) + play(rest)
  end

  def play([]) do
    0
  end

  def result({opponent, you}) do
    result_map(opponent)[you]
  end

  def result_map(opponent) do
    cond do
      opponent == "A" -> %{"Z" => {:win, 8}, "X" => {:loss, 3}, "Y" => {:draw, 4}}
      opponent == "B" -> %{"Z" => {:win, 9}, "X" => {:loss, 1}, "Y" => {:draw, 5}}
      opponent == "C" -> %{"Z" => {:win, 7}, "X" => {:loss, 2}, "Y" => {:draw, 6}}
    end
  end
end

Helpers.Parsing.read_file() |> RockPaperScissors.read_lines()
