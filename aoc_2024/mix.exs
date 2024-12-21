defmodule Aoc2024.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc_2024,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:igniter, "~> 0.3"},
      {:tz, "~> 0.28"},
      {:benchee, "~> 1.3", only: :dev},
      {:req, "~> 0.5"},
      {:nx, "~> 0.9.2"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
