# Deploy using Fly.io

Nindo is hosted over on [Fly.io](https://fly.io). Deploying your own instance to fly is very simple:

```bash
fly deploy
```

That's it :)

## Secrets

Okay, I lied, you need to set the secrets:

```bash
fly secrets set YT_KEY=your-google-api-key-here
```

Nindo needs a YouTube API key to use the Google API to convert some channel URIs to another format. [Read more](https://github.com/RobinBoers/nindo-phx/blob/cdc3177ab642363acb21a4979e5652e4524653c2/lib/nindo_phx_web/live/components/feed-customizer.ex#L87)

Then [generate a key](https://hexdocs.pm/cloak/generate_keys.html) and set it as a secret:

```bash
fly secrets set CLOAK_KEY=your-cloak-key-here
```
