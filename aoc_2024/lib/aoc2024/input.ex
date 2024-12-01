defmodule Aoc2024.Input do
  @moduledoc """
  Input documentation
  """
  @doc """
  Get input for `day` of the year
  """
  def get!(day, year \\ 2024)

  def get!(day, year) do
    case in_cache?(year, day) do
      true ->
        File.read!(tmp_path(year, day))

      _ ->
        download!(year, day)
    end
  end

  def split_input(input, :new_line) do
    Regex.split(~r/\n/, input, trim: true)
  end

  def split_input(input, :spaces) do
    Regex.split(~r/\s/, input, trim: true)
  end

  defp in_cache?(year, day) do
    File.exists?(tmp_path(year, day))
  end

  defp download!(year, day) do
    cookie = Application.get_env(:aoc_2024, :session_cookie)

    {:ok, resp} =
      Req.get("https://adventofcode.com/#{year}/day/#{day}/input",
        headers: %{cookie: "session=#{cookie}"}
      )

    case resp.status do
      200 -> nil
      _ -> exit("Error downloading file with status: #{resp.status} and body: #{resp.body}")
    end

    resp.body |> then(&File.write!(tmp_path(year, day), &1))
    resp.body
  end

  defp tmp_path(year, day) do
    "/tmp/aoc_#{year}_#{day}.txt"
  end
end
