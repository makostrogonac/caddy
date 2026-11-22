# caddy

Custom Caddy build — same plugin set as [juev/caddy](https://github.com/juev/caddy),
rebuilt automatically whenever a new stable Caddy version is released or a plugin updates.

Plugins:

- `github.com/caddy-dns/cloudflare` — DNS-01 challenges (accepts `cfut_`/`cfat_` tokens since March 2026)
- `github.com/mholt/caddy-l4` — layer 4 proxying
- `github.com/lucaslorentz/caddy-docker-proxy/v2` — configure Caddy from Docker labels

## Use

Public image, no login needed:

```yaml
services:
  caddy:
    image: ghcr.io/makostrogonac/caddy:latest
    command: caddy docker-proxy
    ports: ["80:80", "443:443", "443:443/udp"]
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
```

Tags: `latest`, `<version>` (e.g. `2.11.9`), `<minor>` (e.g. `2.11`), and an
immutable build key `caddy-<version>-cf-<sha>-l4-<sha>-dp-<sha>`.

## Builds

`.github/workflows/build.yml` runs daily (and on pushes to this repo). It checks
`caddyserver/caddy`'s latest stable release and the three plugins' branch heads;
if anything changed since the last published build key, it rebuilds for
`linux/amd64` and `linux/arm64` and pushes to GHCR. Manual runs can force a rebuild.
