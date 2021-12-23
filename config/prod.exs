import Config

config :nindo_phx, NindoPhxWeb.Endpoint,
  url: [host: "nindo.fly.dev", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: [
    "https://nindo.fly.dev",
    "https://nindo.geheimesite.nl",
  ]

config :logger, level: :warn
