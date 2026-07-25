# syntax=docker/dockerfile:1

# ── build stage ──────────────────────────────────────────────────────────────
# Alpine + the native Hwaro .apk. Pinned to the version used for local dev so the
# scaffold templates stay compatible. 0.13.0 ships a single (amd64) apk, which
# matches the production target (Hetzner, amd64) and the GitHub Actions runners.
FROM alpine:3.20 AS build

ARG HWARO_VERSION=0.13.0
ARG HWARO_APK=hwaro-${HWARO_VERSION}-r0.apk

RUN apk add --no-cache bash curl \
 && curl -fsSL -o /tmp/hwaro.apk \
      "https://github.com/hahwul/hwaro/releases/download/v${HWARO_VERSION}/${HWARO_APK}" \
 && apk add --allow-untrusted /tmp/hwaro.apk \
 && rm /tmp/hwaro.apk

WORKDIR /site
COPY . .

# Vendor the prose from the app repos (no sibling checkouts in the build context,
# so scripts/vendor.sh uses its raw-GitHub fallback), then build the static site.
RUN bash scripts/vendor.sh && hwaro build --minify

# ── runtime stage ────────────────────────────────────────────────────────────
# busybox-httpd, ~150 KB, serves on :3000 as a non-root user. Traefik terminates
# TLS in front of it, so plain HTTP here is fine.
FROM lipanski/docker-static-website:latest
COPY --from=build /site/public .
