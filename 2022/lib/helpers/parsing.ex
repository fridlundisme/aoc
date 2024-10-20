defmodule Helpers.Parsing do
  alias Helpers.Input

  def read_file() do
    case Input.get_filepath(System.argv()) do
      {:ok, filepath} -> filepath |> File.read!()
      {:error, reason} -> reason
    end
  end

  def read_lines(file) do
    IO.inspect(file)
  end
end
