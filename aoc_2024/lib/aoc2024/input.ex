defmodule Aoc2024.Input do
  @moduledoc """
  Input documentation
  """
  @doc """
  Get input for `day` of the year
  """
  def get!(year \\ 2024, day)

  def get!(year, day) do
    case in_cache?(year, day) do
      true ->
        File.read!(tmp_path(year, day))

      _ ->
        download!(year, day)
    end
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

    resp.body |> then(&File.write!(tmp_path(year, day), &1))
    resp.body
  end

  defp tmp_path(year, day) do
    "/tmp/aoc_#{year}_#{day}.txt"
  end
end
