# syntax=docker/dockerfile:1

# ── stage 1: vendor the tutorials ────────────────────────────────────────────
# The official Hwaro image ships bash + awk but no curl, and scripts/vendor.sh
# needs curl for its raw-GitHub fallback (no sibling checkouts in the build
# context). So we vendor in a tiny Alpine stage first.
FROM alpine:3.20 AS vendor
RUN apk add --no-cache bash curl
WORKDIR /site
COPY . .
RUN bash scripts/vendor.sh

# ── stage 2: build the static site ───────────────────────────────────────────
# Official Hwaro image (multi-arch), pinned to the version used for local dev so
# the scaffold templates stay compatible.
FROM ghcr.io/hahwul/hwaro:0.13.0 AS build
WORKDIR /site
COPY --from=vendor /site .
RUN hwaro build --minify

# ── stage 3: serve ───────────────────────────────────────────────────────────
# busybox-httpd, ~150 KB, serves on :3000 as a non-root user. Traefik terminates
# TLS in front of it, so plain HTTP here is fine. (The Hwaro docs suggest
# nginx:alpine; we prefer the tiny image — size is a selling point of the suite.)
FROM lipanski/docker-static-website:latest
COPY --from=build /site/public .
