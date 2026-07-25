# Happy — tutorial site

[![Live demo](https://img.shields.io/badge/demo-happy.yoteau.fr-blue)](https://happy.yoteau.fr)
[![CI](https://github.com/JadeKharats/happy-site/actions/workflows/ci.yml/badge.svg)](https://github.com/JadeKharats/happy-site/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![GHCR](https://img.shields.io/badge/ghcr-happy--site-purple)](https://github.com/JadeKharats/happy-site/pkgs/container/happy-site)

The publishing site for the **Happy** tutorial series — *learn Crystal web
development by building self-hosted team ritual tools, and pick the right
framework for the problem size.*

Built with [Hwaro](https://github.com/hahwul/hwaro), a static site generator
written in Crystal (building a Crystal tutorial site with a Crystal tool).

## The thin-shell design

The site owns *presentation*; the tutorials' *prose* stays canonical in each app
repo's `TUTORIAL.md`. `scripts/vendor.sh` fetches that prose at build time — from
a sibling checkout when developing locally, from raw GitHub in CI — wraps it with
front matter, an above-the-fold demo/pull line, and the mandatory footer
(repo · demo · GHCR · issues), then generates the sidebar. Code and prose stay in
sync; there is nothing to keep up to date by hand.

Add a tutorial by adding a block to [`tutorials.toml`](tutorials.toml). Nothing
else to touch.

## Local development

Requires the [`hwaro`](https://github.com/hahwul/hwaro) binary on your PATH
(`brew install hahwul/hwaro/hwaro`, pinned to 0.13.0 to match the Dockerfile).

```bash
make serve    # vendor the tutorials, then run the dev server with live reload
make build    # produce the production site in public/
make vendor   # (re)fetch the tutorials only
make clean    # remove build output and vendored content
```

`content/tutorials/*.md` and the generated nav partial are derived artifacts and
are git-ignored — never edit them by hand; fix the prose in the app repo instead.

## Deployment

CI builds the site through the [`Dockerfile`](Dockerfile) on every push/PR (and
weekly, to catch upstream breakage). Tagging `vX.Y.Z` builds and pushes
`ghcr.io/jadekharats/happy-site:X.Y.Z` (and `:latest`) to GHCR and cuts a GitHub
Release.

The Hetzner VPS serves it behind Traefik — see
[`docker-compose.yml`](docker-compose.yml):

```bash
cd /opt/stack/happy && docker compose pull && docker compose up -d
```

The final image is a ~150 KB busybox-httpd container serving static files on
:3000; Traefik terminates TLS and routes `happy.yoteau.fr` to it.

## Licensing

- **Code** (this repo's scripts, templates, config): [MIT](LICENSE).
- **Tutorial content**: CC-BY-SA — it belongs to the app repos it is vendored
  from.
- **No third-party analytics.** This site tracks nothing.

Found a problem or want to contribute a tutorial? Open an issue — that is the
whole point.
