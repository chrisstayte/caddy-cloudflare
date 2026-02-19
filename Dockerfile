# Build on the native platform, cross-compile for the target
ARG CADDY_VERSION=2.10
FROM --platform=$BUILDPLATFORM caddy:${CADDY_VERSION}-builder AS builder

ARG TARGETOS
ARG TARGETARCH

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --output /usr/bin/caddy

# Final image for the target platform
FROM caddy:${CADDY_VERSION}

ARG CADDY_VERSION
LABEL org.opencontainers.image.base.name="caddy:${CADDY_VERSION}"

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Optional: fail the build if the plugin isn't present
RUN caddy list-modules | grep -q dns.providers.cloudflare
