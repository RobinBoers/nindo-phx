# Configuration

You need to configure NindoPhx in `/config/config.exs` and change this configuration:

```elixir
config :nindo,
  base_url: "nindo.geheimesite.nl"
```

This is the URI of the Nindo instance were using (root domain without protocol). Nindo will use this to generate the URIs for RSS feeds.

_Note: I know I should use a Phoenix function for that or something, but the RSS code is all in [RobinBoers/nindo-elixir](https://github.com/RobinBoers/nindo-elixir) so I can't use Phoenix functions there._

Next you can to change the `:invidious_instance` configuration:

```elixir
config :nindo,
  invidious_instance: "yewtu.be"
```

Note that this is optional. This is the Invidious instance Nindo will use for video embeds from YouTube feeds. Only change it if you want to use a Invidious instance that is closer to your end-users. See the [list of all Invidious instances](https://docs.invidious.io/Invidious-Instances.md) for more info.

Last you need to configure the production endpoint in `/config/prod.exs`.

```elixir
config :nindo_phx, NindoPhxWeb.Endpoint,
  url: [host: "nindo.fly.dev", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  check_origin: [
    "https://nindo.fly.dev",
    "https://nindo.geheimesite.nl",
  ]
```

You should configure the main domain you'll be using as the host and any other domains in `:check_origin`.

_Note: again, I know I should only use one domain, but I haven't figured out how to redirect [nindo.fly.dev](https://nindo.fly.dev) to [nindo.geheimesite.nl](https://nindo.geheimesite.nl) :))_
