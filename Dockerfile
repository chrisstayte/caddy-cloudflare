# Build on the native platform, cross-compile for the target
FROM --platform=$BUILDPLATFORM caddy:2.10-builder AS builder

ARG TARGETOS
ARG TARGETARCH

RUN GOOS=${TARGETOS} GOARCH=${TARGETARCH} xcaddy build \
    --with github.com/caddy-dns/cloudflare \
    --output /usr/bin/caddy

# Final image for the target platform
FROM caddy:2.10

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Optional: fail the build if the plugin isn't present
RUN caddy list-modules | grep -q dns.providers.cloudflare