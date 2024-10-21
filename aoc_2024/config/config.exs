import Config

config :elixir, :time_zone_database, Tz.TimeZoneDatabase

config :aoc_2024,
  session_cookie: System.get_env("AOC_SESSION_COOKIE")
