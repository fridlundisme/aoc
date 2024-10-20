defmodule Solution do
  def read_lines(file) do
    operations =
      String.split(file, "\n\n")
      |> Enum.fetch!(1)
      |> String.split("\n")
      |> Enum.map(&moves/1)

    stacks = initial_stacks()
    start(Enum.slice(operations, 0..2), stacks)
  end

  def start([], _) do
    []
  end

  def start([{qty, from, to} | t], stacks) do
    move(stacks, from, to, qty)
  end

  def move(stacks, from, to, qty) do
    stacks[from] = pick_from(stacks[from], qty)
  end

  def put(l, val) do
    [val | l]
  end

  def pick_from(list, 0) do
    list
  end

  def pick_from([h | t], qty) do
    pick_from(t, qty - 1)
  end

  def moves(line) do
    text = String.split(line)

    {qty, from, to} =
      {Enum.fetch!(text, 1) |> String.to_integer(), Enum.fetch!(text, 3), Enum.fetch!(text, 5)}
  end

  def initial_stacks() do
    stack_1 = ["N", "W", "B"]
    stack_2 = ["B", "M", "D", "T", "P", "S", "Z", "L"]
    stack_3 = ["R", "W", "Z", "H", "Q"]
    stack_4 = ["R", "Z", "J", "V", "D", "W"]
    stack_5 = ["B", "M", "H", "S"]
    stack_6 = ["B", "P", "V", "H", "J", "N", "G", "L"]
    stack_7 = ["S", "L", "D", "H", "H", "F", "Z", "Q", "J"]
    stack_8 = ["B", "Q", "G", "J", "F", "S", "W"]
    stack_9 = ["J", "D", "C", "S", "M", "W", "Z"]

    stacks = %{
      "1" => stack_1,
      "2" => stack_2,
      "3" => stack_3,
      "4" => stack_4,
      "5" => stack_5,
      "6" => stack_6,
      "7" => stack_7,
      "8" => stack_8,
      "9" => stack_9
    }
  end
end

Helpers.Parsing.read_file() |> Solution.read_lines()
