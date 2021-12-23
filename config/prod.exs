import Config

config :nindo_phx, NindoPhxWeb.Endpoint,
  url: [host: "nindo.geheimesite.nl", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :warn
