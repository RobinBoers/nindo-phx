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
    name: "NindoPhx",
    source_url: "https://github.com/RobinBoers/nindo-phx",
    docs: [
      main: "overview",
      logo: "logo.png",
      extra_section: "GUIDES",
      api_reference: false,
      extras: extras(),
      groups_for_extras: groups_for_extras(),
      source_ref: "master",
      deps: [nindo: "https://robinboers.github.io/nindo-elixir"]
    ],
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
    {:nindo, git: "git://github.com/RobinBoers/nindo-elixir.git"},
    {:navigation_history, "~> 0.4.0"},
    {:ex_doc, "~> 0.24", only: :dev, runtime: false},
  ]

  defp aliases, do: [
    setup: ["deps.get", "ecto.setup"],
    "ecto.setup": ["ecto.create", "ecto.migrate"],
    "ecto.reset": ["ecto.drop", "ecto.setup"],
    "assets.deploy": ["esbuild default --minify", "phx.digest"],
  ]

  defp extras, do: [
    "docs/overview.md",
    "docs/about.md",
    "docs/api.md",
    "docs/api/auth/login.md",
    "docs/api/accounts/create-account.md",
    "docs/api/accounts/get-account.md",
    "docs/api/accounts/list-accounts.md",
    "docs/api/accounts/modify-account.md",
    "docs/api/posts/create-post.md",
    "docs/api/posts/get-post.md",
    "docs/api/posts/list-posts.md",
  ]

  defp groups_for_extras do
    [
      Introduction: ~r/^(?:(?!\/).)*\/(?!.*\/).*$/,
      API: ~r/docs\/api\/auth\/.?/,
      Accounts: ~r/docs\/api\/accounts\/.?/,
      Posts: ~r/docs\/api\/posts\/.?/,
    ]
  end
end
