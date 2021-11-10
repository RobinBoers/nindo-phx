import Config

config :nindo_phx, NindoPhxWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: NindoPhxWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: NindoPhx.PubSub,
  live_view: [signing_salt: "vjxpT+JX"]

config :nindo_phx, NindoPhx.Mailer, adapter: Swoosh.Adapters.Local

config :swoosh, :api_client, false

config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"

config :nin_db,
   ecto_repos: [NinDB.Repo]

config :nin_db, NinDB.Repo,
  database: "nindb",
  hostname: "localhost",
  log: false
