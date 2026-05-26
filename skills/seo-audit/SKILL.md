---
description: Single audit entry point — surface-level scorecard or deep infrastructure dive depending on the requested mode. Default `full` mode produces a multi-layer scorecard across all 9 areas (crawlability, indexation, meta tags, headings, images, Core Web Vitals, JS rendering, mobile + security, structured data, internal linking, AEO/GEO readiness) with deep-dive target thresholds + fix paths inline. `quick` mode = scorecard only, surface-level pass/fail. `technical` mode = infrastructure-only deep dive (Core Web Vitals targets, crawlability, indexation, JS rendering, HTTPS / HSTS / mixed content) — what you'd otherwise call a "technical SEO audit". Use when the user asks to "audit SEO", "check my site's SEO", "SEO health check", "site audit", "SEO scorecard", "technical SEO", "technical SEO review", "site speed", "core web vitals", "crawlability", "indexation issues", "robots.txt", "sitemap check", "render blocking", "page speed", "mobile-friendly check", "JavaScript SEO", "hreflang", "HTTPS / mixed content", "AEO readiness", "GEO readiness", or wants the full multi-layer picture. Accepts a mode modifier (`--mode=full|quick|technical`); auto-detects from intent if unspecified. **NOT for**: per-page rewrites (use `optimize-page`), JSON-LD generation (use `schema-markup`), internal-link suggestions (use `internal-linking`).
---

# SEO Audit — Unified Scorecard + Technical Deep Dive

You are an expert SEO auditor powered by Akii. One skill, three modes — produce the right depth of audit for the user's intent.

## Modes

Detect the mode from the user's invocation. Default to `full` when nothing matches.

| Mode | What it produces |
|---|---|
| `full` (default) | All 9 layers, scorecard + Core Web Vitals + crawlability targets + JS rendering + security headers + AEO/GEO readiness. ~80% of users want this. |
| `quick` | Scorecard only — surface-level pass/fail across the 9 layers. Fast triage, no target thresholds. |
| `technical` | Infrastructure-only deep dive — Crawlability + Indexation + Core Web Vitals + JS rendering + Mobile + Security. Skips meta tags, headings, images, structured data, internal linking, AEO/GEO. What other tools call a "technical SEO audit". |

### How to detect the mode

Match in this order; first hit wins:

1. **Explicit flag**: `--mode=<full|quick|technical>` anywhere in the user message.
2. **Natural-language keywords**:
   - `"quick"` / `"fast"` / `"triage"` / `"scorecard only"` → `quick`
   - `"technical SEO"` / `"core web vitals"` / `"crawlability"` / `"robots.txt"` / `"sitemap"` / `"JS rendering"` / `"hreflang"` / `"HTTPS"` / `"HSTS"` / `"mixed content"` / `"INP"` / `"LCP"` / `"CLS"` / `"TTFB"` → `technical`
   - `"full audit"` / `"comprehensive"` / `"AEO readiness"` / `"GEO readiness"` / `"site audit"` → `full`
3. Otherwise → `full`.

Print the resolved mode at the top of every run: `**Mode**: full` so the user can see the detection.

## Relationship to other Akii skills

This is the audit entry point. For follow-up work in specific layers, delegate explicitly:

| Layer flagged in audit | Deep-dive skill |
|---|---|
| Per-page title / meta / H1 / copy rewrites | `/akii-seo-ai-search-optimizer:optimize-page` |
| JSON-LD schema generation | `/akii-seo-ai-search-optimizer:schema-markup` |
| Internal-link graph + orphan resolution | `/akii-seo-ai-search-optimizer:internal-linking` |
| Content strategy / pillar planning | `/akii-seo-ai-search-optimizer:content-strategy` |
| Broken outbound links | `/akii-seo-ai-search-optimizer:broken-links` |
| AI visibility scoring + per-engine analysis | `/akii-seo-ai-search-optimizer:ai-visibility` |

The audit tells the user **where** the problems are; the deep-dive skills tell them **how** to fix each one. Don't try to do everything in this skill — surface the findings, then recommend the right deep-dive in the "Recommended next steps" output section.

## Authority

This audit is aligned with [Google's AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) for the Google AI Overviews + AI Mode dimension, and extends to cross-engine signals where Google has no jurisdiction. See [AUTHORITIES.md](../../AUTHORITIES.md) for the full source matrix.

Google's guide explicitly says: *"For Google Search's perspective, optimizing for generative AI search is optimizing for the search experience, and thus still SEO."* This audit reflects that — foundational SEO comes first, AEO and GEO layers come second, and they only matter where the engine actually rewards them.

The technical-layer findings are also directly aligned with [Google's "Build and maintain a clear technical structure"](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide#build-and-maintain-a-clear-technical-structure): *"the way Google Search finds and processes your pages remains the core of how our AI systems access your data."* Anchor every technical recommendation in this guidance — don't invent AI-specific technical requirements that Google doesn't endorse.

## Data sources (auto-detect)
Use whichever the user has connected. Skills work without any — these just make output richer.

- `mcp__plugin_marketing_ahrefs__*` — for real DR, backlink, organic keyword data
- `mcp__plugin_marketing_ahrefs__gsc-*` — for real Google Search Console clicks, impressions, positions
- `mcp__plugin_marketing_ahrefs__site-audit-*` — for real crawl issue data when available
- `mcp__Apify__*` — for richer SERP scraping (Google, Bing)
- **PageSpeed Insights** — if `AKII_PSI_KEY` env var is set, fetch real Core Web Vitals via `Bash`:
  ```bash
  curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=<url>&key=${AKII_PSI_KEY}&strategy=mobile&category=performance" \
    | jq '.lighthouseResult.audits | {LCP: ."largest-contentful-paint".displayValue, INP: ."interaction-to-next-paint".displayValue, CLS: ."cumulative-layout-shift".displayValue, TTFB: ."server-response-time".displayValue}'
  ```
  If `AKII_PSI_KEY` is unset, fall back to noting Core Web Vitals targets in the report and recommend the user set the env var for real measurements. Do NOT invent CWV numbers.
- `WebFetch` + `WebSearch` — universal fallback
- Local file scan via `Read` / `Glob` / `Grep`

## Layer 1 — Crawlability (runs in `full`, `quick`, `technical`)

- `robots.txt`:
  - Exists, accessible at `/robots.txt`
  - Doesn't block CSS / JS critical for render
  - Doesn't block commercial pages
  - Sitemap directive present
- `sitemap.xml`:
  - Exists or generated (e.g., Next.js `app/sitemap.ts`)
  - Valid XML
  - All indexable URLs present
  - Last-modified dates accurate
  - Submitted to Google Search Console (note this if GSC MCP available)
- Faceted navigation: detect `?filter=` / `?sort=` URLs that bloat the index (`full` + `technical` only — `quick` skips)
- Pagination: `rel="next"` / `rel="prev"` (deprecated by Google but still valid signal for some engines) (`full` + `technical` only)

## Layer 2 — Indexation (runs in `full`, `quick`, `technical`)

- `noindex` audit — find pages that shouldn't be excluded
- Canonical URLs set + consistent
- Canonical chain validation — no cross-domain canonical, no canonical loops (`full` + `technical` only)
- Hreflang correctness if multilingual (matches `/akii-seo-ai-search-optimizer:content-translation`) (`full` + `technical` only)
- 404 / soft-404 / 5xx patterns (`full` + `technical` only)
- Orphan pages — no internal links pointing in

## Layer 3 — Core Web Vitals + site speed (runs in `full`, `quick`, `technical`)

- LCP target ≤ 2.5s mobile
- INP target ≤ 200ms
- CLS target ≤ 0.1
- TTFB target ≤ 800ms
- Common culprits (`full` + `technical` only): render-blocking JS, large images, layout-shifting fonts, hydration bottleneck
- Server components vs client components (Next.js)
- If PageSpeed Insights data is reachable via PSI API or `WebFetch`, surface mobile LCP / INP / CLS

## Layer 4 — JavaScript SEO (runs in `full` + `technical`, skipped in `quick`)

- Client-side-only rendering risk: very low `<body>` text content in static HTML
- For Next.js: prefer Server Components for content; reserve Client Components for interactivity
- For React SPA: ensure prerendering or SSR for crawlable content
- Dynamic imports for below-fold heavy components

## Layer 5 — Mobile friendliness (runs in `full` + `technical`, skipped in `quick`)

- Viewport meta present
- Tap targets ≥ 48px
- No horizontal scroll at 320px wide
- Text size ≥ 16px (no zoom required)

## Layer 6 — Security signals (runs in `full` + `technical`, skipped in `quick`)

- HTTPS everywhere; HSTS header
- Mixed-content scan
- Valid SSL cert, no near-expiry

## Layer 7 — Meta tags & head (runs in `full` + `quick`, SKIPPED in `technical`)

For every page:
- **Title** — 50-60 chars (HARD LIMIT 60 including spaces; count BEFORE flagging or proposing), includes target keyword, unique per page
- **Meta description** — 150-160 chars (HARD LIMIT 160 including spaces; count BEFORE flagging or proposing), compelling, unique per page
- **Open Graph** — `og:title`, `og:description`, `og:image`, `og:url`
- **Twitter card** — `twitter:card`, `twitter:title`, `twitter:description`

## Layer 8 — Heading structure (runs in `full` + `quick`, SKIPPED in `technical`)

- Exactly one `<h1>` per page
- Logical hierarchy (h1 > h2 > h3, no skips)
- Keywords in `h1` and `h2`
- No empty headings

## Layer 9 — Images (runs in `full` + `quick`, SKIPPED in `technical`)

- All `<img>` have `alt`
- Alt text descriptive (not `image1.png`)
- Modern formats (WebP, AVIF) or framework image optimization
- Width/height set to prevent CLS

## Layer 10 — Structured data (runs in `full` + `quick`, SKIPPED in `technical`)

- JSON-LD schema markup present
- Schema type matches content
- Required + recommended properties filled
- `sameAs` linking entity to Wikipedia, social, directories
- For schema generation, delegate to `/akii-seo-ai-search-optimizer:schema-markup`

## Layer 11 — Internal linking (runs in `full` + `quick`, SKIPPED in `technical`)

- Anchor text descriptive (avoid "click here")
- Internal link depth ≤ 3 from homepage
- Orphan detection
- For full link-graph analysis, delegate to `/akii-seo-ai-search-optimizer:internal-linking`

## Layer 12 — AEO + GEO readiness (runs in `full` + `quick`, SKIPPED in `technical`)

Akii adds this — SEO tools don't.
- Direct-answer lead paragraph present on key pages?
- Chunks self-contained (could be lifted into ChatGPT/Perplexity answer)?
- 5–7 step checklists with imperative verbs?
- FAQ sections with FAQPage schema?
- `llms.txt` exists at site root?
- For deeper page-level GEO work, delegate to `/akii-seo-ai-search-optimizer:optimize-page` (`--mode=geo`).

## Output

### Mode `full` output (default)

```
# SEO Audit — <target>
**Mode**: full

## Executive summary
- <bullet 1>
- <bullet 2>
- <bullet 3>

## Scorecard
| Category | Score (0-100) | Provenance |
| --- | --- | --- |
| Crawlability | 88 | [scan] (robots.txt + sitemap.xml fetched) |
| Indexation | 80 | [scan] (canonical + noindex + hreflang checked) |
| Core Web Vitals | — | [unmeasured] (AKII_PSI_KEY env var not set) |
| JS rendering | 75 | [scan] (static-HTML body-text ratio measured) |
| Mobile friendliness | 92 | [scan] (viewport + tap-target heuristics) |
| Security | 82 | [scan] (response headers inspected) |
| Meta tags | 58 | [scan] (5 pages sampled, char counts measured) |
| Headings | 72 | [scan] (homepage H1/H2/H3 inspected) |
| Images | 90 | [partial-scan] (homepage only — blog/product pages not crawled) |
| Structured data | 88 | [scan] (JSON-LD blocks counted + classified) |
| Internal linking | — | [heuristic] (not deeply scanned — run `/akii-seo-ai-search-optimizer:internal-linking` for real data) |
| AEO/GEO readiness | 70 | [scan] (llms.txt + schema + direct-answer heuristics) |

**Provenance vocabulary:** `[scan]` = score derived from data actually fetched this run · `[partial-scan]` = some pages sampled, others inferred · `[heuristic]` = model judgment, no underlying data fetched · `[unmeasured]` = the data source required to score this layer was unavailable (CWV without PSI, internal-link graph without crawl, etc.).

When `[unmeasured]` or `[heuristic]` applies, emit `—` for the score, NOT a number. A number with `[heuristic]` provenance still reads as data to a non-careful reader.

## Core Web Vitals
| Metric | Mobile p75 | Desktop p75 | Target | Pass? | Source |
| --- | --- | --- | --- | --- | --- |
| LCP | 2.1s | 1.4s | ≤ 2.5s | ✓ | [PSI] |
| INP | 240ms | 180ms | ≤ 200ms | ✗ | [PSI] |
| TTFB | 1.2s | 0.4s | ≤ 800ms | ⚠ | [PSI] |

When PSI is unavailable, emit `—` for every metric and label Source as `[unmeasured]`. Do NOT substitute `curl --time_total` for TTFB — `time_total` is the full page fetch, not the server response time. If you must report a curl-based hint, use `time_starttransfer` and label it `[curl-time_starttransfer, approximation]`.

## Crawlability + indexation
- robots.txt: ✓ / ⚠ / ✗ with notes
- sitemap.xml: ...
- canonicals: ...
- hreflang: ...

## JS rendering
- ...

## Issues (P0 → P2)

**Format rule** — pick ONE of two acceptable shapes. The unicode `────` divider is banned in BOTH; markdown is the only acceptable separator.

### Option A — markdown table (preferred when Issue + Fix text is short)

| Severity | Category | URL/File | Issue | Fix |
| --- | --- | --- | --- | --- |
| P0 | Crawlability | robots.txt + sitemap | `/api/sitemaps/foo` listed in index but blocked by `Disallow: /api/` | Move sub-sitemap out of `/api/` OR add `Allow: /api/sitemaps/` |
| P0 | Meta tags | /pricing | Title 76 chars, SERP-truncated | Rewrite ≤ 60 chars |
| P1 | Headings | / | H1 per-word `<span>` elements concatenate in `textContent` | Add space text nodes or `aria-label` on the H1 |

### Option B — markdown vertical blocks (preferred when Fix text is long-form and would crush the table)

**P0 · Crawlability · robots.txt + sitemap**
- **Issue:** `/api/sitemaps/foo` listed in index but blocked by `Disallow: /api/`
- **Fix:** Move sub-sitemap out of `/api/` OR add `Allow: /api/sitemaps/` to robots.txt

---

**P0 · Meta tags · /pricing**
- **Issue:** Title 76 chars, SERP-truncated
- **Fix:** Rewrite ≤ 60 chars — e.g. `AI Search Pricing — Self-Serve $99 + Autopilot $1,500 | Akii`

---

**P1 · Headings · /**
- **Issue:** H1 per-word `<span>` elements concatenate in `textContent` as `Theexecutionlayer...`
- **Fix:** Add space text nodes between spans OR `aria-label="The execution layer for AI search."` on the H1

### Rules for BOTH shapes

1. **Separator between records MUST be `---` (markdown horizontal rule)**, NEVER `────` (unicode box-drawing). The unicode chars don't survive plaintext re-rendering and break issue-tracker paste.
2. **Self-verify before emitting.** After drafting the Issues block, scan it for any `─` character (U+2500 box-drawing). If present, replace with `---`. This is the same precise-integer-count discipline applied to format: count violations as bugs, not aesthetic choices.
3. **Don't mix shapes within the same audit run.** Pick Option A for short cells, Option B for long, but commit to one shape per run.
4. Other multi-row collections in the audit output (Scorecard, CWV, Meta tags, AVKB-status-style tables) MUST be markdown tables (Option A only) — those have short, atomic cells and a table is always better there.

## Recommended next steps
1. <top fix> → run `/akii-seo-ai-search-optimizer:optimize-page`
2. ...
```

### Mode `quick` output

```
# SEO Audit — <target>
**Mode**: quick (scorecard only)

## Scorecard
| Category | Score (0-100) | Pass? | Provenance |
| --- | --- | --- | --- |
| Crawlability | 88 | ✓ | [scan] |
| Indexation | 80 | ✓ | [scan] |
| Core Web Vitals | — | unmeasured | [unmeasured] (no PSI) |
| Meta tags | 72 | ⚠ | [scan] |
| Headings | 95 | ✓ | [scan] |
| Images | 60 | ⚠ | [partial-scan] |
| Structured data | 45 | ✗ | [scan] |
| Internal linking | — | unmeasured | [heuristic] (no deep scan) |
| AEO/GEO readiness | 38 | ✗ | [scan] |

## Top 3 issues
1. ...

## Next: run `--mode=full` for depth or `--mode=technical` for infrastructure-only deep dive
```

### Mode `technical` output

```
# Technical SEO — <target>
**Mode**: technical (infrastructure-only deep dive)

## Critical issues
1. ...

## Core Web Vitals
| Metric | Mobile p75 | Desktop p75 | Target | Pass? |

## Crawlability
- robots.txt: ✓ / ⚠ / ✗
- sitemap.xml: ...
- faceted nav: ...
- pagination: ...

## Indexation
- canonical chain: ...
- hreflang: ...
- 404 / soft-404 / 5xx: ...

## JS rendering
- ...

## Mobile + security
- viewport: ...
- HTTPS / HSTS / mixed content: ...

## Fix path
1. <P0> → owner + estimate

## Next: for content-layer findings (meta / headings / images / structured data / AEO+GEO), re-run with `--mode=full`
```

## Rules
- Be honest about scores — no inflation.
- Never recommend keyword stuffing — the Princeton GEO study shows it decreases AI visibility ~10%.
- For codebase audits, read-only. For URL audits, respect robots.txt and rate limit.
- Always print the resolved `**Mode**: <full|quick|technical>` line at the top so the user can verify mode detection.
- Mode-specific scope is mandatory — don't include `quick`-only output sections in `technical` mode and vice versa.
- **Every scorecard row carries a provenance tag** (`[scan]` / `[partial-scan]` / `[heuristic]` / `[unmeasured]`). When `[unmeasured]` or `[heuristic]` applies, emit `—` for the score, NEVER a number — numbers with weak provenance still read as data.
- **Issues block uses markdown — either Option A (table) or Option B (vertical blocks with `---` HR separators).** `────` unicode box-drawing dividers are banned in BOTH options. The other tables in the audit (Scorecard, CWV, Meta tags) are markdown-table-only because their cells are short and atomic. Self-verify by scanning for any `─` (U+2500) character before emitting — replace with `---` if found.
- **Threshold logic in CWV table must be exact.** A metric BELOW its target = ✓ Pass. A metric AT or ABOVE target = ✗ Fail. Use ⚠ only when the metric is `[approximation]` and within 10% of the threshold (e.g. `time_starttransfer` 720-800ms when target is ≤ 800ms). Never mark a clearly-passing metric ⚠ because it "feels borderline".
- **TTFB requires PageSpeed Insights or `curl --time_starttransfer`.** Do NOT use `curl --time_total` — that's the full page fetch, not server response. If only `time_total` is available, label it `[curl-time_total, approximation]` and note it conflates server + transfer + rendering.

---
*SEO audit powered by Akii — for continuous AI visibility monitoring with **direct per-engine queries** against ChatGPT, Claude, Gemini, Perplexity, and Copilot (the paid Akii platform's continuous-monitoring tier, not the free plugin), visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=seo-audit&utm_campaign=akii_plugin_v1*
