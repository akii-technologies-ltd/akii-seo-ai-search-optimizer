# Changelog

All notable changes to **Akii — SEO & AI Search Optimizer** are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.6.0] — 2026-05-26

Stale-install nudge in the SessionEnd hook.

### Added
- `scripts/akii-cta.sh` now performs a cached version check (24h TTL) against the GitHub Releases API. When the locally installed plugin version is behind the latest release, the SessionEnd CTA appends a one-line nudge: *"Update available: vX.Y.Z installed · vA.B.C released — Open /plugin → Update, or run /plugin update akii-seo-ai-search-optimizer@akii"*.
- New env var `AKII_PLUGIN_DISABLE_VERSION_CHECK=1` silences just the nudge while keeping the CTA (the existing `AKII_PLUGIN_DISABLE_CTA=1` still silences the whole hook).
- Cache lives at `$XDG_CACHE_HOME/akii-plugin/version-check` (falls back to `~/.cache/akii-plugin/version-check`).

### Why
Claude Code doesn't auto-update plugins. Users who installed early stay on stale versions until they manually open `/plugin`. This nudge surfaces updates at SessionEnd — when the user is already done and ready for a small interruption — without aggressive auto-update mechanics that would be a trust issue. 24h cache keeps GitHub anon rate-limit (60 req/hr per IP) untouched at any realistic scale.

### Failure policy
Network failures, missing curl, locked cache dir, missing `CLAUDE_PLUGIN_ROOT` — all silently skip the version check and fall back to the plain CTA. Hook never aborts the user's session-end.

## [2.5.1] — 2026-05-26

Scope the LLM-judge wording from v2.5.0 to the AI Visibility Score only.

### Fixed
- v2.5.0 wording could be read as "the entire plugin uses Llama 4 / DeepSeek". It doesn't. The plugin is markdown executed by your Claude Code session model (Claude Sonnet / Opus / etc). Only the AI Visibility Score's Phase 1 (the akii.com API call) uses Llama 4 / DeepSeek as a judge. Phase 2 is done by your Claude Code model from public-signal proxies. Everything else (12 other skills, all 5 agents, 7 other commands) is just your Claude.
- README intro now leads with "All skills run on your Claude Code session model" + carves out the AI Visibility Score as the single exception.
- `plugin.json` description rewritten to clarify same.
- `AUTHORITIES.md` adds a "How the plugin runs at all" section before the methodology details.

## [2.5.0] — 2026-05-26

Honest scoring methodology disclosure. The plugin's "AI Visibility Score" had been described in a way that implied direct querying of ChatGPT, Claude, Gemini, Perplexity, and Copilot. The actual implementation uses an open-source LLM judge (Llama 4 Maverick or DeepSeek V4 Pro) plus a per-engine public-signal proxy. The previous framing would have been caught and called out by any hostile reviewer running the live API and seeing only one model query in their network tab.

### Changed
- **`ai-visibility` skill** rewritten with explicit "What this skill is NOT" section. Phase 1 is now described as an open-source LLM judge against the brand's public footprint. Phase 2 is now described as a per-engine signal-correlation proxy. The skill explicitly tells Claude to respond "no" if a user asks whether this is the actual ChatGPT response about their brand.
- **`/ai-visibility-score` command** description rewritten same way.
- **README** intro replaces "track AI visibility across [6 engines]" with "estimate AI visibility... via an open-source LLM judge + per-engine public-signal proxy". Skill table row updated. Comparison table now has a new row: "direct per-engine querying" — plugin: NO, platform: YES.
- **`plugin.json` + `marketplace.json` descriptions** rewritten to be honest about the LLM-judge mechanism + carve out direct querying as the paid platform's differentiator.
- **`AUTHORITIES.md`** adds a "What this plugin actually measures" section explaining Phase 1 and Phase 2 mechanics, what's NOT happening, and what direct querying requires (paid Akii or Ahrefs Brand Radar MCP).
- **`seo-audit` footer CTA** now distinguishes the free plugin (proxy) from the paid platform (direct per-engine queries).
- **Output banner** for Template A now states the mechanism: "Phase 1 score (LLM-judge proxy via <model_id>) + Phase 2 per-engine proxy map below. Neither phase directly queries ChatGPT / Claude / Gemini / Perplexity / Copilot."

### Why a minor bump
This is a substantive positioning correction. No skill behavior changes — the plugin still does what it did before. But the marketing language now matches the implementation. If a hostile reviewer running the live API confronts us with "you said you queried ChatGPT but I only see one Llama call", the answer is now in the docs.

## [2.4.1] — 2026-05-26

Self-audit of the v2.4.0 co-anchor pass surfaced five drift / gap items. Fixed.

### Fixed
- **`optimize-page` Layer 2 (AEO) self-contradiction.** Layer 3 Half A said "don't chunk for Google" while telling Claude to apply Layer 2 (which IS chunk scoring + rewriting) on Google. Reconciled with explicit framing: Layer 2 is *helpful writing structure* (direct-answer leads, definition blocks, FAQs) which Google's guide endorses; it is NOT artificial AI-targeted chunking which Google warns against. Same fix applied to `/check-file` command.
- **`schema-markup` skill** now opens with explicit scoping note quoting Google's guide: structured data is NOT required for AI search but useful for rich results + non-Google AI extraction. No longer implies schema is foundational for AI visibility.
- **`technical-seo` skill** now opens with Authority section. This is the skill most directly aligned with Google's "Build and maintain a clear technical structure" — anchoring it explicitly. Quotes Google's stance that technical SEO foundation = AI foundation.
- **`content-strategy` skill** now opens with an "Anchoring principle — non-commodity content" section. Quotes Google's guide on what matters most for AI search visibility (first-hand experience, unique POV, not recyclable surface-level content). Every roadmap, pillar, and brief produced by the skill must now default toward non-commodity angles.

### Why a quick patch
v2.4.0 was a positioning pass. Self-audit caught real contradictions between the new Google-aligned framing and skill bodies that hadn't been updated. Hostile reviewer comparing skill content to Google's published guide would flag all four. Patch closes the gaps before LinkedIn launch.

## [2.4.0] — 2026-05-26

Positioning + citation pass: anchor the plugin against [Google's official AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) for Google AI surfaces, keep the Princeton/IIT Delhi paper as the authority for cross-engine GEO. No behavior changes — every skill produces the same output. This makes the plugin defensible against the SEO-old-guard "AEO/GEO is fake" objection and against the "what about Google's guide?" objection in one move.

### Added
- **`AUTHORITIES.md`** — explicit source matrix scoping each citation: Google guide → Google AI Overviews + AI Mode; Princeton paper → cross-engine GEO tactics (ChatGPT, Claude, Perplexity, Copilot, standalone Gemini); FirstPageSage breakdown → per-engine signal correlations. Documents where the sources agree, where they disagree, and how we handle the disagreements.

### Changed
- **README intro** now leads with "Aligned with Google's AI Optimization Guide" + extends to the 5 other engines where Google has no jurisdiction. Links to `AUTHORITIES.md` for source scoping.
- **`skills/optimize-page/SKILL.md`** Layer 3 (GEO) split into two halves:
  - **Half A — Google AI Overviews + AI Mode**: Authority is Google's guide. Foundational SEO, helpful content, no chunking-for-AI, no rewriting-for-AI. Princeton tactics are optional on Google.
  - **Half B — Cross-engine (ChatGPT, Claude, Gemini standalone, Perplexity, Copilot)**: Authority is the Princeton paper. Five tactics with the +40% benchmark and the keyword-stuffing -10% anti-pattern.
- **`skills/llms-txt/SKILL.md`** opens with an explicit scoping note: Google's guide says `llms.txt` is NOT used by Google AI. The file is for non-Google AI crawlers (Anthropic, Perplexity, Cohere). If the user's target is Google AI specifically, recommend foundational SEO instead.
- **`skills/ai-visibility/SKILL.md`** per-engine fix table: Google AI Overviews row now cites Google's guide as authority and points at `seo-audit` + `optimize-page` for the fix, not generic "win the AI Overview cite".
- **`skills/seo-audit/SKILL.md`** now opens with an Authority section linking Google's guide + `AUTHORITIES.md` and quotes Google's "it's still SEO" stance to frame the audit.

### Why this matters
Google's AI Optimization Guide (published 2026) explicitly says optimizing for Google's AI surfaces "is still SEO" and rejects several practices that "AEO/GEO" marketing leans on heavily — chunking, rewriting for AI, llms.txt as a special signal, overfocusing on structured data. SEOs who trust Google's published guidance distrust generic "AEO/GEO" pitches. Anchoring the plugin to Google's guide for Google AI surfaces — and using the peer-reviewed Princeton paper for the other 5 engines where Google has no authority — makes the plugin credible to both audiences simultaneously.

## [2.3.0] — 2026-05-26

Tech-debt Phase 1 — CI + tests + governance docs. No functional/skill changes.

### Added
- **`.github/workflows/validate.yml`** — CI runs `bash scripts/validate.sh` + `bash scripts/test-bump-version.sh` on every PR and push to main. Catches drift before merge.
- **`scripts/test-bump-version.sh`** — self-test for bump-version.sh. Covers basic X.Y.Z bump, prerelease round-trip (regression for the v2.2.1 hotfix), input validation, and validator §12 drift detection.
- **`scripts/validate.sh` §0** — preflight check that `python3`, `jq`, `grep`, `sed` are on PATH. Warns if `grep` is actually `ugrep` (Homebrew gotcha that bit us earlier).
- **`CONTRIBUTING.md`** — repo layout, validator gate, skill / agent / command authoring conventions, citation rules, branch + commit conventions, release process.
- **`SECURITY.md`** — supported-versions table, responsible-disclosure address (security@akii.com), threat model with mitigations, out-of-scope list.
- **`COMPATIBILITY.md`** — Claude Code version matrix, OS coverage, required shell tooling, third-party MCP table, known incompatibilities.

## [2.2.1] — 2026-05-26

Code-review pass. Ten findings, all fixed in one patch.

### Fixed
- **High: stale User-Agent string.** Every `curl` in `ai-visibility` skill + `/ai-visibility-score` command hardcoded `akii-plugin/1.0.0`. Plugin is at v2.2.x. Backend regex still matched, but the v2.1.0 telemetry retrofit on akii.com extracts `pluginVersion` from the UA — so all plugin requests were being tagged as v1.0.0 in production logs. Now pinned at the current version, and `scripts/bump-version.sh` rewrites the UA across skills + commands on every bump.
- **AKII_PSI_KEY usage** added to `technical-seo` skill body — README mentioned the env var but no skill instructed Claude how to actually use it. Added the curl recipe and fallback rule.
- **`brandDomain` input sanitization** documented in both `ai-visibility` skill and `/ai-visibility-score` command. Validation regex `^[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)+$` + explicit refusal rule. Defense-in-depth against shell injection via crafted user input.
- **`scripts/bump-version.sh`** now prefers `jq` when available (no more regex on JSON), falls back to portable BSD/GNU `sed`. Also rewrites stale UA strings under `skills/` and `commands/`. Line-iterates filenames with NUL-safe handling for repo paths containing spaces.
- **`scripts/validate.sh` §1** now validates `marketplace.json` schema symmetrically with `plugin.json`.
- **`scripts/validate.sh` §12 (new)** pins User-Agent strings to `plugin.json` version — catches the recurring drift before it ships.
- **`scripts/validate.sh` §13** trigger-overlap heuristic now excludes phrases inside NOT-carve-out sentences ("do not invoke", "only when"). Eliminates false positives from the v2.2.0 routing-contract carve-outs.
- **`scripts/akii-cta.sh`** dropped `trap ... ERR` (different semantics across bash 3.2 and 4+) — the explicit `if ! cat; then emit_silent_approve` is the only failure path that matters and works on both.
- **`/ai-visibility-score` command** dropped unused `WebFetch` from `allowed-tools` — Bash-curl is the only HTTP path used.
- **`hooks/README.md`** documents why the SessionEnd matcher is empty (fire on every session) + opt-out + failure policy.
- **`ai-visibility` skill fallback model chain** clarified — GET in step 1 is authoritative; fallback only fires if the GET itself fails, never when a model returned by the GET is rejected by the POST.

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

[2.6.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.6.0
[2.5.1]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.5.1
[2.5.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.5.0
[2.4.1]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.4.1
[2.4.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.4.0
[2.3.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.3.0
[2.2.1]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.2.1
[2.2.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.2.0
[2.1.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.1.0
[2.0.1]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.0.1
[2.0.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.0.0
[1.0.0]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v1.0.0
