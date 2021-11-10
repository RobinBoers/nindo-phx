defmodule NindoPhx.MixProject do
  use Mix.Project

  def project, do: [
    app: :nindo_phx,
    version: "0.1.0",
    elixir: "~> 1.12",
    elixirc_paths: elixirc_paths(Mix.env()),
    compilers: [:gettext] ++ Mix.compilers(),
    start_permanent: Mix.env() == :prod,
    aliases: aliases(),
    deps: deps(),
  ]

  def application, do: [
    mod: {NindoPhx.Application, []},
    extra_applications: [:logger, :runtime_tools],
  ]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps, do: [
    {:phoenix, "~> 1.6.2"},
    {:phoenix_html, "~> 3.0"},
    {:phoenix_live_reload, "~> 1.2", only: :dev},
    {:phoenix_live_view, "~> 0.16.0"},
    {:floki, ">= 0.30.0", only: :test},
    {:phoenix_live_dashboard, "~> 0.5"},
    {:esbuild, "~> 0.2", runtime: Mix.env() == :dev},
    {:swoosh, "~> 1.3"},
    {:telemetry_metrics, "~> 0.6"},
    {:telemetry_poller, "~> 1.0"},
    {:gettext, "~> 0.18"},
    {:jason, "~> 1.2"},
    {:plug_cowboy, "~> 2.5"},
    {:nindo, path: "../nindo"},
    {:feeder_ex, "~> 1.1.0"},
    {:rss, "~> 0.2.1"},
    {:httpoison, "~> 1.8"},
    {:calendar, "~> 1.0.0"},
  ]

  defp aliases, do: [
    setup: ["deps.get"],
    "assets.deploy": ["esbuild default --minify", "phx.digest"],
  ]
end
