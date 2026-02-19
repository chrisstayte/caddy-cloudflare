# caddy-cloudflare

Custom Caddy Docker image with the [Cloudflare DNS provider module](https://github.com/caddy-dns/cloudflare) preinstalled.

This repository builds and publishes a multi-arch image (`linux/amd64`, `linux/arm64`) to GitHub Container Registry:

- `ghcr.io/chrisstayte/caddy-cloudflare:latest`
- Semver tags from releases (for example `1.2.3`)
- Caddy base tag (for example `caddy-2.10`)

Published images also include the `org.opencontainers.image.base.name` label so the upstream Caddy version is easy to identify.

## What this image includes

- Official `caddy` image as the base image
- Binary rebuilt with `xcaddy` and:
  - `github.com/caddy-dns/cloudflare`
- Build-time validation that `dns.providers.cloudflare` is present

## Prerequisites

- Docker (or Docker Compose)
- A domain managed in Cloudflare
- A Cloudflare API token with DNS edit permissions for your zone

## Quick setup (Docker Compose)

1. Create a working directory and move into it.
2. Create a `Caddyfile` (example below).
3. Create persistent folders:
   - `caddy_data`
   - `caddy_config`
4. Create a `compose.yml`:

```yaml
services:
  caddy:
    image: ghcr.io/chrisstayte/caddy-cloudflare:latest
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - ./caddy_data:/data
      - ./caddy_config:/config
    environment:
      - CLOUDFLARE_API_TOKEN=your_token_here
```

5. Start Caddy:

```bash
docker compose up -d
```

## Example Caddyfile

This example serves `example.com` and uses DNS challenge with Cloudflare for TLS certificates:

```caddy
example.com {
	tls {
		dns cloudflare {env.CLOUDFLARE_API_TOKEN}
	}

	respond "Hello from Caddy + Cloudflare DNS!"
}
```

## Build locally

To build the image from this repository:

```bash
docker build -t caddy-cloudflare:test .
```

## How publishing works

On push to `main`, GitHub Actions:

1. Bumps the version and creates a tag
2. Builds and pushes the Docker image to GHCR
3. Creates a GitHub release

---

Why do programmers prefer dark mode? Because light attracts bugs.
