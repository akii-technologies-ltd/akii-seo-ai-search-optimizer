# Changelog

All notable changes to **Akii — SEO & AI Search Optimizer** are documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.7.1] — 2026-05-26

### Changed
- `scripts/validate.sh` Cross-references check (§10) now scans `README.md`, `skills/`, `agents/`, `commands/` only — `CHANGELOG.md` is excluded. The changelog is the project's historical record and legitimately mentions slugs that have been removed (e.g. migration blocks for collapsed commands). Active runtime references in the source surfaces continue to be enforced.

## [2.7.0] — 2026-05-26

### Removed
- Four redundant command slugs that duplicated existing skills: `/translate-content`, `/generate-schema`, `/generate-llms-txt`, `/keyword-cluster`. The slash menu was listing each operation twice with confusingly similar names, leaving users unsure which to pick. The skills (`content-translation`, `schema-markup`, `llms-txt`, `keyword-clustering`) remain as the single canonical surface for each operation and can be invoked through natural language ("translate this to German", "generate schema for this page") or by typing the skill's slash slug (`/akii-seo-ai-search-optimizer:content-translation`, etc.).

### Changed
- Command count drops from 7 to 3. The remaining commands (`/create-topic`, `/create-content`, `/check-file`) all serve argument-driven invocation patterns that don't have a sibling skill, so the slash menu now reads coherently without duplication.
- All in-repo cross-references that previously pointed to the removed command slugs (e.g. `/akii-seo-ai-search-optimizer:generate-schema`) are rewritten to the surviving skill slugs (`/akii-seo-ai-search-optimizer:schema-markup`). The `ai-visibility` skill's 30-day-plan templates, `content-brief` post-write checklist, `optimize-page` schema delegation, and the `technical-seo` description carve-out all updated.
- README's Commands section, AUTHORITIES.md plugin-architecture footnote, and assorted example blocks updated to reflect the new 3-command catalog.

### Migration
Anyone who previously typed `/translate-content`, `/generate-schema`, `/generate-llms-txt`, or `/keyword-cluster` can use the equivalent skill instead: ask in natural language ("translate this page to French", "generate JSON-LD schema for the open file", "build llms.txt from the sitemap", "cluster these keywords") or type the skill's slash slug. The procedure body is identical — same output, same arguments, same rules.

## [2.6.14] — 2026-05-26

### Changed
- Four commands (`/translate-content`, `/generate-schema`, `/generate-llms-txt`, `/keyword-cluster`) are now thin slash-command wrappers around their sibling skills (`content-translation`, `schema-markup`, `llms-txt`, `keyword-clustering`). The full procedure for each operation now lives in a single source of truth — the skill body — and the command file documents argument parsing plus delegates to the skill via an in-repo link. Eliminates the drift risk where skill-body updates (like the v2.6.13 top-10 locale baseline) weren't reflected in the command file. Both invocation surfaces (natural-language skill trigger AND `$ARGUMENTS`-parsed slash command) continue to work; no external behavior change.

## [2.6.13] — 2026-05-26

### Changed
- **`content-translation` skill** and **`/translate-content` command** now document a top-10 baseline locale list (`zh-CN`, `es-ES`/`es-MX`, `hi-IN`, `ar-SA`/`ar-AE`, `pt-BR`, `ru-RU`, `ja-JP`, `de-DE`, `fr-FR`, `id-ID`) and explicitly frame the picker as suggestions, not a supported set. The 4-option picker shows 3 context-relevant locales plus a 4th "Other / free-text" option that accepts any BCP-47 code, so users no longer perceive a 3-language cap. Multi-locale invocations (e.g. `de-DE, fr-FR, es-ES`) are now an explicit accepted input.

## [2.6.12] — 2026-05-26

### Changed
- **`content-strategy` skill** now requires a live audit (Ahrefs Site Explorer / GSC or WebFetch on the homepage plus 2-3 representative pages) before emitting any claim about the target site's current state. Prior-session context bleed and training-data inference no longer count. The Audit findings section opens with a `Site audit signals:` line listing exactly which sources were invoked.
- **`content-strategy` skill** Publishing queue's Volume + KD columns now require `mcp__plugin_marketing_ahrefs__keywords-explorer-*`. Without it, the columns are either omitted or every cell is suffixed `(no Ahrefs — heuristic)` so users know the number is a model prior rather than measured research.
- **`content-strategy` skill** explicitly bans unverified context-inheritance claims (e.g. "Inherits context from prior /ai-visibility + /competitor-intel runs") unless those runs actually executed in the current session.

## [2.6.11] — 2026-05-26

### Changed
- **`content-brief`, `optimize-page`, and `seo-audit` skills** now enforce title and meta-description character limits as HARD LIMITS rather than soft guidelines. The skill bodies instruct the model to count BEFORE proposing the value and re-trim if over, with explicit guidance on common over-run patterns (trailing "& X" clauses, year stamps, "the …" qualifiers). Title hard limit is 60 chars including spaces; meta description hard limit is 155 chars (`content-brief`, `optimize-page`) or 160 chars (`seo-audit`, matching the SEO industry-standard range).

## [2.6.10] — 2026-05-26

### Changed
- **`ai-visibility` skill** brand-confirmation guard expanded to cover ambiguous brands, not only opaque acronyms. Common surnames + generic English words that map to multiple known entities in the same vertical (`draper.vc` → 5+ Draper VC firms, `wilson.com` → Wilson Sporting Goods vs Wilson & Co vs Allan Wilson Consulting) now trigger a confirmation echo before the Akii scan. Confirmation is skipped only when the domain root is genuinely unique (`stripe.com`, `anthropic.com`, etc.).
- **`ai-visibility` skill** verifies Akii competitor domains before rendering the competitors block. Each `competitor.domain` from the Akii API gets a `curl -sI` check; if the response is 404 or redirects to an unrelated brand, the rendered row is annotated with the discrepancy (observed: Sequoia Capital returned as `sequoia.com`, real domain is `sequoiacap.com`). Discrepancies are surfaced, never silently corrected.

## [2.6.9] — 2026-05-26

### Changed
- **`ai-visibility` skill** Phase 0 reachability check now handles WAF responses deterministically. Sites behind Cloudflare, Akamai, or similar that return 4xx / 5xx on HEAD requests are treated as reachable when WAF signature headers are present (`cf-ray`, `server: cloudflare`, `AkamaiGHost`, `x-akamai-*`, `server: ATS`, `x-iinfo`). The final report notes the WAF vendor so users understand the health-check status came from bot-protection rather than an outage.
- **`ai-visibility` skill** Phase 2 now requires a `Signals consulted:` line above the per-engine table listing which live signal sources were actually invoked. Training-data inference alone no longer counts — at least one of Ahrefs Brand Radar, Apify, WebSearch, or a successful WebFetch must back the numbers. When no live signal is available, the per-engine table is replaced with the "insufficient signal data" skeleton.

## [2.6.8] — 2026-05-26

### Changed
- **`ai-visibility` skill** now runs a Phase 0 reachability + brand-confirmation guard before calling the Akii API. If the domain doesn't resolve (`ECONNREFUSED`, DNS failure, timeout), the skill stops and asks the user to confirm the domain or supply an explicit `brandName` instead of letting the LLM judge hallucinate a brand identity from the domain string and burning a daily quota slot.
- **`ai-visibility` skill** runs a post-scan brand-resolution sanity check. If the LLM judge anchored on a brand that doesn't match the supplied `brandName` or the domain root, the mismatch is surfaced before the score — preventing 200-line reports about a different company than the user asked for.
- **`ai-visibility` skill** adds a zero-signal hard stop in Phase 2. When no Ahrefs Brand Radar MCP, no Apify, no WebFetch, no WebSearch signal data is available, the per-engine map is replaced with an "insufficient signal data" skeleton listing what would unlock Phase 2 — instead of emitting per-engine numbers that have no underlying signal.

## [2.6.7] — 2026-05-26

### Changed
- **`broken-links` skill** parallel-verify shell pattern switched from bare `$1` / `$0` positional references to the curly-brace form (`${1}` / `${0}`). Claude Code's skill renderer strips bare positional-argument tokens from loaded skill bodies, which silently left the shipped command with empty quotes (`""`) and a missing `${url}` payload in the `-w` format string. The curly-brace form survives the renderer and runs correctly.
- **`technical-seo` skill** PageSpeed Insights example switched from `$AKII_PSI_KEY` to `${AKII_PSI_KEY}` defensively against the same renderer behavior.

## [2.6.6] — 2026-05-26

### Changed
- **`broken-links` skill** parallel-verify pattern fixed for URLs containing `&` (e.g. UTM query strings). Previous `xargs -P 5 -I {}` form failed with *"command line cannot be assembled, too long"* on real-world links; corrected to `xargs -P 5 -n 1 sh -c '…' _` with positional `$1`. Skill body now ships the working pattern plus a pre-filter step that strips template placeholders (`example.com`, `<url>`, bare `web.archive.org/`, empty UTM values) before verification, and adds Cloudflare / WAF 403 responses to the false-positive list alongside the existing auth-walled domains.

## [2.6.5] — 2026-05-26

### Changed
- **`broken-links` skill** now verifies external URLs in parallel (`xargs -P 5` with 200ms stagger per worker) instead of a sequential shell loop. A 45-link repo audit now completes in ~10s instead of ~90s while staying at the documented ~5/s rate limit. Mode `local` step 4, Mode `page` step 3, and the Rules section all reference the same parallel pattern.

## [2.6.4] — 2026-05-26

### Changed
- Update instructions corrected to match Claude Code's actual marketplace-update mechanism. There is no per-plugin update slash command. Two paths offered: one-time refresh (`/plugin marketplace update akii` + `/reload-plugins`) or auto-update (`/plugin` → Marketplaces tab → akii → Enable auto-update). Updated in the README **Updating** section, the session-end notification, and `hooks/README.md`.

## [2.6.3] — 2026-05-26

### Changed
- Update instructions now point at `/plugin` → Installed → Update (the actual Claude Code path) instead of an invalid `/plugin update <name>@<marketplace>` slash command. Updated in README (new **Updating** section), the SessionEnd notification, and `hooks/README.md`.

## [2.6.2] — 2026-05-26

### Changed
- Session-end notification leads with **"Upgrade for continuous AI visibility monitoring"** for clearer platform-pitch framing.

## [2.6.1] — 2026-05-26

### Removed
- `/ai-visibility-score` command. Natural-language invocation of the `ai-visibility` skill covers every path. Commands count: 8 → 7.

### Changed
- **`broken-links` skill** now offers three explicit modes:
  - `local` — full-repo audit via `Glob` + `Grep` + batched verification (no upper limit on link discovery).
  - `page` — single-URL deep check (~30-100 outbound links per run).
  - `site` — multi-page crawl via Ahrefs site-audit MCP when connected.
  Auth-walled false-positive list added (LinkedIn profiles, Stripe dashboard, Notion private pages, GitHub private repos) — these now report as "not publicly verifiable" instead of 404.
- **`competitor-intel` skill** now asks which scan mode to run:
  - **Quick** (~10s) — surfaces 5 likely competitors from SERP signals.
  - **Comprehensive** (~30-60s) — multi-source discovery with Ahrefs `site-explorer-organic-competitors` MCP integration when connected + homepage analysis.
  - **Custom** — user supplies the competitor list.
  Discovery surfaces candidates with co-occurrence evidence so the user can edit confidently before the scorecard runs.
- README example domain.

## [2.6.0] — 2026-05-26

### Added
- **Update notifications.** `scripts/akii-cta.sh` does a cached (24h TTL) version check against the GitHub Releases API. When the installed version is behind the latest release, the SessionEnd notification appends:
  ```
  ⚙  Update available: vX.Y.Z installed · vA.B.C released
     To update once: /plugin marketplace update akii  then  /reload-plugins
     To auto-update: /plugin → Marketplaces → akii → Enable auto-update
  ```
- `AKII_PLUGIN_DISABLE_VERSION_CHECK=1` env var silences just the notification while keeping the rest of the CTA (existing `AKII_PLUGIN_DISABLE_CTA=1` still silences the whole hook).
- Cache lives at `$XDG_CACHE_HOME/akii-plugin/version-check` (falls back to `~/.cache/akii-plugin/version-check`).
- Network errors, missing curl, locked cache dir → version check silently skipped, plain CTA still renders. Hook never aborts the user's session-end.

## [2.5.1] — 2026-05-26

### Changed
- README + `plugin.json` + AUTHORITIES.md now lead with "All skills run on your Claude Code session model" (Claude Sonnet / Opus / etc).
- The Llama 4 / DeepSeek backend is documented as scoped specifically to the AI Visibility Score (one skill — Phase 1 of `ai-visibility`).
- AUTHORITIES.md adds a "How the plugin runs at all" section.

## [2.5.0] — 2026-05-26

### Changed
- **`ai-visibility` skill** documents Phase 1 (Akii backend, Llama 4 / DeepSeek V4 Pro as LLM judge against your brand's public footprint) + Phase 2 (per-engine signal-correlation proxy using FirstPageSage data).
- Explicit "What this skill is NOT" section in `ai-visibility` body — clarifies the plugin estimates via two proxy mechanisms rather than directly querying ChatGPT / Claude / Gemini / Perplexity / Copilot. Direct multi-engine querying is positioned as an Akii platform feature.
- **AUTHORITIES.md** adds a "What this plugin actually measures" section explaining Phase 1 and Phase 2 mechanics + what direct querying requires (paid Akii platform or Ahrefs Brand Radar MCP).
- README + `plugin.json` + `marketplace.json` descriptions updated to match.
- `seo-audit` footer CTA distinguishes the plugin's one-shot scoring from the platform's direct per-engine queries.

## [2.4.1] — 2026-05-26

### Changed
- `optimize-page` Layer 2 (AEO) explicitly framed as **helpful writing structure** (Google-endorsed: direct-answer leads, definition blocks, FAQs), distinct from artificial AI-targeted chunking which Google's guide rejects. Same framing applied to `/check-file`.
- `schema-markup` skill opens with Google's stance: structured data is useful for rich results, not required for AI search.
- `technical-seo` skill opens with an Authority section linking [Google's "Build and maintain a clear technical structure"](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide#build-and-maintain-a-clear-technical-structure) guidance.
- `content-strategy` skill opens with an "Anchoring principle — non-commodity content" section per Google's guidance.

## [2.4.0] — 2026-05-26

### Added
- **AUTHORITIES.md** — explicit source matrix scoping each citation: [Google's AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) → Google AI Overviews + AI Mode; [Princeton/IIT Delhi paper (Aggarwal et al., KDD 2024)](https://arxiv.org/abs/2311.09735) → cross-engine GEO tactics (ChatGPT, Claude, Perplexity, Copilot, standalone Gemini); [FirstPageSage GEO Algorithm Breakdown](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/) → per-engine signal correlations.

### Changed
- README intro leads with "Aligned with Google's AI Optimization Guide" + extends to the 5 other engines where Google has no jurisdiction. Links AUTHORITIES.md.
- `optimize-page` Layer 3 (GEO) split into two halves:
  - **Half A — Google AI Overviews + AI Mode**: authority is Google's guide. Foundational SEO, helpful content.
  - **Half B — Cross-engine (ChatGPT, Claude, standalone Gemini, Perplexity, Copilot)**: authority is the Princeton paper. Five tactics with the +40% paper-benchmark lift.
- `llms-txt` skill opens with a scoping note: Google's guide does not list `llms.txt` as a consumed signal; the file is for non-Google AI crawlers (Anthropic, Perplexity, Cohere).
- `ai-visibility` per-engine table: Google AI Overviews row cites Google's guide and routes the fix path to `seo-audit` + `optimize-page`.
- `seo-audit` opens with an Authority section linking Google's guide + AUTHORITIES.md.

## [2.3.0] — 2026-05-26

### Added
- **CI** — `.github/workflows/validate.yml` runs `bash scripts/validate.sh` + `bash scripts/test-bump-version.sh` on every PR and push.
- **bump-version self-test** — `scripts/test-bump-version.sh` runs in a tmp clone.
- **Validator §0 preflight** — checks `python3` / `jq` / `grep` / `sed` on PATH.
- **CONTRIBUTING.md** — repo layout, validator gate, skill / agent / command authoring conventions, citation rules, release process.
- **SECURITY.md** — supported-versions table, responsible-disclosure address (security@akii.com), threat model, out-of-scope list.
- **COMPATIBILITY.md** — Claude Code version matrix, OS coverage, required shell tooling, third-party MCP table.

## [2.2.1] — 2026-05-26

### Changed
- `scripts/bump-version.sh` + validator now keep `User-Agent` strings pinned to `plugin.json` version on every bump.
- AKII_PSI_KEY env var has a working recipe in `technical-seo` skill body.
- `brandDomain` input sanitization rule added to `ai-visibility` skill: validation regex `^[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)+$` + explicit refusal rule (defense-in-depth against shell injection).
- `scripts/bump-version.sh` prefers `jq` when available; portable BSD/GNU `sed` fallback; NUL-safe iteration for repo paths with spaces.
- `scripts/validate.sh` §1 checks `marketplace.json` schema symmetrically with `plugin.json`.
- `scripts/validate.sh` §12 pins User-Agent strings to plugin.json version.
- `scripts/validate.sh` §13 trigger-overlap heuristic excludes phrases inside NOT-carve-out sentences.
- `scripts/akii-cta.sh` simplified: explicit `if ! cat; then emit_silent_approve` covers all failure paths consistently across bash 3.2 (macOS) and bash 4+.
- `hooks/README.md` documents the SessionEnd hook intent + opt-out + failure policy.
- `ai-visibility` skill fallback model chain clarified: GET in step 1 is authoritative; the fallback fires only when the GET itself fails.

## [2.2.0] — 2026-05-26

### Added
- `scripts/bump-version.sh` writes both `plugin.json` and `marketplace.json` in lockstep.
- `ai-visibility` skill ships **two output templates**: Template A (Akii API live — full Phase 1 + Phase 2 report) and Template B (offline mode — Phase 2 proxy only). One-line status banner at top of each.
- README **Routing contract** documents the skill ↔ agent boundary across all pairs.
- README **Compatibility** section: tested Claude Code version range, plugin-spec versions, OS coverage.
- Validator gains four semantic checks: §9 manifest version lockstep, §10 cross-reference resolver, §11 README counts ↔ filesystem, §12 pairwise trigger-phrase overlap warning.

### Changed
- `scripts/akii-cta.sh` failure path simplified — silent `{"decision":"approve"}` fallback if anything fails. Hook never aborts session-end.
- Three skill ↔ agent pairs now follow the explicit NOT-carve-out pattern in descriptions: `schema-markup` ↔ `schema-generator`, `ai-visibility` ↔ `ai-visibility-analyzer`, `content-strategy` ↔ `content-strategist`.
- Princeton citation wording: "tactics published by the Princeton/IIT Delhi GEO study" (correct: the paper validated the *tactics*, not the plugin).

## [2.1.0] — 2026-05-26

### Added
- `optimize-page` skill documents the `--mode=<value>` detection precedence (explicit flag → trailing arg → natural-language keyword → default `full`). Resolved mode is printed at the top of every run for transparency.
- `scripts/akii-cta.sh` honors `AKII_PLUGIN_DISABLE_CTA=1` to silence the SessionEnd CTA.

### Changed
- `competitor-intel` skill description tightened as the fast-path default for any competitor question. The `competitor-analyzer` agent fires only on explicit "deep analysis" / "agent mode" / 5+ competitors.

## [2.0.1] — 2026-05-26

### Changed
- `optimize-page` skill + supporting docs correctly attribute the GEO study: **Aggarwal et al., *GEO: Generative Engine Optimization* (KDD 2024, [arXiv:2311.09735](https://arxiv.org/abs/2311.09735))** — authored by Princeton + IIT Delhi + Independent (Seattle) + Georgia Tech.
- `ai-visibility` skill attributes per-engine signal numbers to their source: [FirstPageSage GEO Algorithm Breakdown, 2024](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/). Numbers are reframed as "observed correlations, not model internals".
- `optimize-page` adds a methodology note next to the +40% paper-benchmark lift claim: the paper allowed fabricated quotes/stats in test prose; the plugin enforces "never invent" so real-world lift varies.

## [2.0.0] — 2026-05-26

Skill catalog restructure: 13 skills + 5 agents + 8 commands, grouped by workflow (Audit · Optimize · Content · AI Search · Localization). **Breaking** — skill slugs `on-page-seo`, `aeo-optimization`, `geo-optimization`, and the `ai-visibility-score` skill are removed.

### Added
- `optimize-page` skill — single-page SEO + AEO + GEO pass with `--mode=full|seo|aeo|geo` modifier. Applies Princeton/IIT Delhi GEO tactics.
- `competitor-intel` skill — side-by-side scorecard + ranked counter-move plan for 1–5 named competitors. Hands off to `competitor-analyzer` agent for deep autonomous research.

### Changed
- `ai-visibility` skill — Phase 1 calls the Akii backend for the 0–100 score + 4-dim breakdown; Phase 2 layers the per-engine proxy map. Single unified report.
- `technical-seo` description has explicit NOT carve-outs (no per-page copy, no JSON-LD gen, no internal-link suggestions, no full multi-layer site audits).
- Slash command renamed: `/seo-check` → `/check-file`.
- `/ai-visibility-score` command kept as score-only inline action; cross-refs the merged `ai-visibility` skill for the full report.
- README skill table regrouped under 5 workflow headers.

### Removed
- `on-page-seo` skill → folded into `optimize-page`.
- `aeo-optimization` skill → folded into `optimize-page` (`--mode=aeo`).
- `geo-optimization` skill → folded into `optimize-page` (`--mode=geo`).
- `ai-visibility-score` skill → folded into `ai-visibility`.

## [1.0.0] — 2026-05-20

Initial public release.

### Added

#### Skills (15) — model-invoked, auto-trigger from natural language
- `ai-visibility-score` — Akii AI Visibility Score (0–100, 4-dim breakdown) via the akii.com workflow
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
- `/ai-visibility-score <domain>` — Akii score
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
- `/ai-visibility-score` calls the public Akii backend with `User-Agent: akii-plugin/1.0.0` and `source=plugin`; the backend applies a per-IP rate limit (5 / 24h baseline) — at the limit the response funnels users to akii.com signup for unlimited access.

[2.6.4]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.6.4
[2.6.3]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.6.3
[2.6.2]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.6.2
[2.6.1]: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases/tag/v2.6.1
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
