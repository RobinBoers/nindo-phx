import Config

config :nindo_phx, NindoPhxWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "t3au4WpsQPyFkLzVEWYkxHAKo+0TUysaSdlW9wVmLwQX2rIjQBOmTxImU43GLhzS",
  server: false

config :nindo_phx, NindoPhx.Mailer, adapter: Swoosh.Adapters.Test

config :logger, level: :warn

config :phoenix, :plug_init_mode, :runtime
