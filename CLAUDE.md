# Tutorial site

See ../CLAUDE.md for suite-wide conventions.

Do not let this become the project. It is a thin shell around content that
lives elsewhere. Build it after motivators ships, not before.

## Purpose

Publish the tutorial series in English. One page per tutorial. Every page opens
with a live demo link and a GHCR pull command, above the fold.

The pitch: learn Crystal web development by building self-hosted team ritual
tools — and pick the right framework for the problem size.

## Content location — decided: Option A

`TUTORIAL.md` is canonical in each app repo (`motivators/`, `kudos/`, `api/`).
The site vendors/fetches them at build time so code and prose stay in sync.
The build complexity is the price we pay for zero drift — accept it.

Rejected — Option B (content lives here): simpler build, but guaranteed drift
between a tutorial and the code it documents.

Never edit tutorial prose in this repo. Fix it in the app repo, then re-vendor.

## Stack — decided: Hwaro

**Hwaro** (hahwul's static site generator, written in Crystal) —
https://hwaro.hahwul.com, https://github.com/hahwul/hwaro, MIT.

Why, over the alternatives we evaluated:
- Crystal SSG → keeps the "build the Crystal tutorial site with a Crystal tool"
  narrative.
- Stable config, `docs`/`book` built-in theme that fits "one page per tutorial",
  and a clear, Docker-inclusive deployment story (a GitHub Action + GitHub Pages
  are documented). Lowest-risk of the Crystal options.

Rejected:
- **Nicolino** (ralsina): strongest narrative (author very active in the Crystal
  community), but its README warns the config format can change without notice —
  bad for a tutorial meant to stay copyable. Keep as a fallback if Hwaro stalls.
- **mkdocs-material**: the boring, zero-risk escape hatch. Only if both Crystal
  SSGs cost more than an evening of debugging.

Notes for building:
- Templates are Crinja (Jinja2-like); front matter is TOML.
- Config is TOML with per-env variants (`config.production.toml`).
- Deploy via the GitHub Action to GitHub Pages (see Hwaro's deployment docs);
  Docker is also documented if we ever host it on the Hetzner VPS instead.

## Content rules

- English. A French translation may come later; never the reverse.
- No "Management 3.0" branding. The practice names (moving motivators, kudo
  cards, niko-niko) are in common use, but the trademark is not ours to lean
  on. Describe instead: self-hosted team rituals.
- No third-party analytics. Self-hosted or none — it would be absurd to ship
  a privacy-minded suite on a site that leaks visitors.
- CC-BY-SA on content, MIT on code samples. State it in the footer.
- Each tutorial page ends with: the GitHub repo, the demo, the GHCR image, and
  an invitation to open issues. The point of all this is to recruit
  contributors.
