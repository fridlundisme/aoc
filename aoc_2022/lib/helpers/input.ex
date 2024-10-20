defmodule Helpers.Input do
  defp fetch([val | _]) do
    {:ok, val}
  end

  defp fetch([]) do
    {:error, "no args"}
  end

  def get_filepath(args) do
    case fetch(args) do
      {:ok, day} -> {:ok, "#{Path.relative("lib/day-#{day}/input.txt")}"}
      {:error, reason} -> {:error, reason}
    end
  end
end
