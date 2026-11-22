#syntax=docker/dockerfile:1
# Same plugin set as ghcr.io/juev/caddy, rebuilt automatically on every new
# Caddy release by .github/workflows/build.yml.
ARG CADDY_VERSION=2
FROM caddy:${CADDY_VERSION}-builder AS builder

ARG CADDY_VERSION
ARG CLOUDFLARE_REF=master
ARG L4_REF=master
ARG DOCKER_PROXY_REF=master

ENV GOCACHE=/root/.cache/go-build
ENV GOMODCACHE=/go/pkg/mod

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    xcaddy build "v${CADDY_VERSION}" \
    --with "github.com/caddy-dns/cloudflare@${CLOUDFLARE_REF}" \
    --with "github.com/mholt/caddy-l4@${L4_REF}" \
    --with "github.com/lucaslorentz/caddy-docker-proxy/v2@${DOCKER_PROXY_REF}"

FROM caddy:${CADDY_VERSION}-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
CMD ["caddy", "docker-proxy"]
