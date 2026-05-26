# Changelog

All notable changes to **Akii — SEO & AI Search Optimizer** are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.2.0] — 2026-05-26

Architectural hardening pass after dogfooding the plugin against itself + an /architecture ADR-style review. No breaking changes.

### Added
- `scripts/bump-version.sh` writes both `plugin.json` and `marketplace.json` in lockstep (A5).
- `ai-visibility` skill now ships **two output templates**: Template A (Akii API succeeded) and Template B (offline mode — Phase 2 proxy only). Each starts with a one-line status banner so the user knows which mode they're seeing. Closes the "half-broken report when akii.com is down" failure mode (A2).
- README **Routing contract** documents the skill-vs-agent boundary. Agents only fire on explicit `deep` / `agent mode` / `autonomous` / `bulk` triggers; skills are the default fast path.
- README **Compatibility** section documents tested Claude Code version range, plugin-spec versions, and OS coverage (A7).
- Validator gains four new semantic checks (A1):
  - §9 manifests in lockstep
  - §10 cross-reference resolver (catches dangling `/akii-seo-ai-search-optimizer:<slug>` refs)
  - §11 README counts must match filesystem
  - §12 pairwise trigger-phrase overlap warning

### Changed
- Hook script `scripts/akii-cta.sh` no longer aborts on partial failure. `trap ERR` falls back to a silent `{"decision":"approve"}` so the user's session-end is never broken by hook noise (A4).
- Three skill/agent pairs now follow the v2.1.0 competitor-intel pattern — explicit NOT-carve-outs in descriptions (A0):
  - `schema-markup` ↔ `schema-generator` (one page vs bulk)
  - `ai-visibility` ↔ `ai-visibility-analyzer` (one-turn vs autonomous deep probe)
  - `content-strategy` ↔ `content-strategist` (one-turn vs multi-pass site + competitor)
- Princeton citation wording across README, optimize-page skill, and section headings reframed from "Princeton-validated" (implies the paper validated *Akii*) to "tactics published by the Princeton/IIT Delhi GEO study" (correct: the paper validated the *tactics*).

## [2.1.0] — 2026-05-26

Pre-launch hardening pass (P1 + P2). No breaking changes.

### Added
- `optimize-page` skill now documents how to detect `--mode=<value>` (explicit flag, trailing argument, or natural-language keyword) with explicit precedence rules. Resolved mode is printed at the top of every run for transparency.
- `scripts/akii-cta.sh` honors `AKII_PLUGIN_DISABLE_CTA=1` to silence the SessionEnd CTA. Header comment now references the Searchfit-precedent compliance pattern and points users to the opt-out.

### Changed
- `competitor-intel` skill description tightened: this is the fast-path default for any competitor question. Hands off to the `competitor-analyzer` agent ONLY on explicit "deep analysis" / "agent mode" / 5+ competitors.
- `competitor-analyzer` agent description tightened in reverse: deep autonomous research only. Removes the generic "analyze competitors" trigger phrases that overlapped with the skill.

## [2.0.1] — 2026-05-26

Pre-launch citation hotfix. No functional changes.

### Fixed
- `optimize-page` skill, CHANGELOG, and 5 launch docs no longer credit "Allen Institute" for the GEO study. Aggarwal et al., *GEO: Generative Engine Optimization* (KDD 2024, [arXiv:2311.09735](https://arxiv.org/abs/2311.09735)) is Princeton + IIT Delhi + Independent (Seattle) + Georgia Tech.
- `ai-visibility` skill now attributes per-engine signal numbers to their actual source ([FirstPageSage GEO Algorithm Breakdown, 2024](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/)) and reframes them as "observed correlations, not model internals". Skill instructs Claude to attribute when surfacing the numbers.
- `optimize-page` adds methodology caveat next to the +40% lift claim: the paper allowed fabricated quotes/stats; the plugin enforces "never invent" so real-world lift varies.
- `launch/09-devto.md`: stale "15 model-triggered skills" → 13. Wrong agent file path (`agents/<name>/AGENT.md`) → canonical flat `agents/<name>.md`.

## [2.0.0] — 2026-05-26

Pre-launch surface restructure. Reduces plugin from 15 skills to 13 by merging redundant on-page optimization skills and unifying AI-visibility entry points. Adds `competitor-intel`. **Breaking** — skill slugs `on-page-seo`, `aeo-optimization`, `geo-optimization`, `ai-visibility-score` (skill) are removed.

### Added
- `optimize-page` skill — single-page SEO + AEO + GEO pass with `--mode=full|seo|aeo|geo` modifier. Princeton GEO method preserved.
- `competitor-intel` skill — side-by-side scorecard + ranked counter-move plan for 1–5 named competitors. Delegates deep crawls to `competitor-analyzer` agent.

### Changed
- `ai-visibility` skill rewritten — Phase 1 calls the real Akii API for the 0–100 score + 4-dim breakdown; Phase 2 layers the proxy per-engine vulnerability map. Single unified report.
- `technical-seo` description tightened with explicit NOT carve-outs (no per-page copy, no JSON-LD gen, no internal-link suggestions, no full site audits).
- `/seo-check` command renamed → `/check-file` (matches what it does).
- `/ai-visibility-score` command kept as score-only inline action; cross-refs the merged `ai-visibility` skill for the full report.
- README skill table regrouped under 5 workflow headers (Audit · Optimize · Content · AI Search · Localization).

### Removed
- `on-page-seo` skill → folded into `optimize-page`.
- `aeo-optimization` skill → folded into `optimize-page` (`--mode=aeo`).
- `geo-optimization` skill → folded into `optimize-page` (`--mode=geo`).
- `ai-visibility-score` skill → folded into `ai-visibility`.

## [1.0.0] — 2026-05-20

Initial public release.

### Added

#### Skills (15) — model-invoked, auto-trigger from natural language
- `ai-visibility-score` — Real 0–100 Akii AI Visibility Score (4-dim breakdown) via the official Akii workflow at akii.com/api/ai-visibility-score
- `seo-audit` — Comprehensive SEO + AEO + GEO site health check
- `technical-seo` — Core Web Vitals, crawlability, indexation, JS rendering, security
- `on-page-seo` — Single-page optimization for target keyword + AEO chunk quality
- `broken-links` — 404 / 5xx / redirect-chain auditor
- `internal-linking` — Orphan detection, anchor diversity, link-equity flow
- `schema-markup` — JSON-LD generator with `sameAs`, granular `LocalBusiness` subtypes, AEO fields
- `content-strategy` — Pillar + cluster topology + publishing queue
- `content-brief` — SERP-grounded brief with PAA + entity coverage
- `keyword-clustering` — Intent-matched topical clusters → page mapping
- `ai-visibility` — Per-engine vulnerability map (ChatGPT / Gemini / Perplexity / Claude / Copilot) using public SERP proxy signals
- `aeo-optimization` — Chunk-quality auditing + direct-answer leads + FAQ extraction
- `geo-optimization` — Princeton/IIT Delhi GEO method, Aggarwal et al. KDD 2024 (up to +40% AI visibility lift)
- `llms-txt` — Generate / maintain `llms.txt` + `llms-full.txt`
- `content-translation` — Per-locale keyword research + hreflang + cultural adaptation

#### Agents (5) — autonomous, multi-step workflows
- `seo-auditor` — Full autonomous site audit with scored report
- `content-strategist` — Site + competitor analysis → complete content plan
- `competitor-analyzer` — Side-by-side scorecard + ranked counter-moves
- `ai-visibility-analyzer` — Per-engine vulnerability map with 30-day fix plan
- `schema-generator` — Bulk JSON-LD generation across many pages

#### Slash commands (8)
- `/ai-visibility-score <domain>` — Real Akii score
- `/create-topic <seed>` — Full topic plan
- `/create-content <topic>` — Full SEO + AEO + GEO-optimized article
- `/generate-schema [type]` — JSON-LD for current file or URL
- `/keyword-cluster <keywords>` — Cluster + map
- `/seo-check [file]` — Quick on-page check
- `/translate-content <language>` — Localize with hreflang
- `/generate-llms-txt` — Build `llms.txt` + optional `llms-full.txt`

#### Hooks
- `SessionEnd` — Renders a first-party Akii continuity link in the terminal (compliant with Anthropic Usage Policy; never generated by the model)

#### Third-party MCP auto-detection
- Ahrefs (`mcp__plugin_marketing_ahrefs__*`) — DR, backlinks, organic keywords, Brand Radar, GSC
- Apify (`mcp__Apify__*`) — SERP scraping, social-mention scraping
- DataForSEO — SERP, keyword, backlink data
- PageSpeed Insights API (via `AKII_PSI_KEY` env var) — Core Web Vitals

### Technical notes
- Plugin works standalone with Claude Code built-in tools (`Read`, `Glob`, `Grep`, `Bash`, `WebFetch`, `WebSearch`)
- No login, no signup, no usage cap — fully MIT-licensed
- `/ai-visibility-score` calls the public Akii backend with `User-Agent: akii-plugin/1.0.0` and `source=plugin`; the backend bypasses browser-only reCAPTCHA for plugin requests and applies a per-IP rate limit (5 / 24h baseline) — at the limit the response funnels users to akii.com signup for unlimited access

[2.2.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.2.0
[2.1.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.1.0
[2.0.1]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.0.1
[2.0.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.0.0
[1.0.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v1.0.0
