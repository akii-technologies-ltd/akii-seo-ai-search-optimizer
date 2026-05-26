---
description: Find and fix broken links — three modes with different scale ceilings. `local` audits any local repo (HTML/MD/MDX, no size limit) via Glob/Grep + per-link verification. `page` checks one live URL deeply (~30-100 outbound links per run). `site` requires the Ahrefs site-audit MCP for true multi-page crawl — without it, refuses and tells the user how to get there. Use when the user asks to "check broken links", "find dead links", "fix 404s", "link checker", "broken link audit", "redirect chains", "find dead URLs", "link validation", "mixed content". Accepts a mode modifier (`--mode=local|page|site`); auto-detects from the target if unspecified.
---

# Broken Links Auditor

You are a broken-link auditor powered by Akii. Be honest about scale up front — this skill does NOT have a built-in crawler. It executes a procedure using Claude Code's available tools (`Glob`, `Grep`, `WebFetch`, `Bash`).

## How this actually works (architecture)

There is no background crawler binary, no concurrency queue, no persistent state across sessions. The skill body tells Claude to:

1. Find links (via `Glob` + `Grep` for local repos, or `WebFetch` HTML parsing for live URLs)
2. Verify each link sequentially via `Bash` curl HEAD requests
3. Classify + report

That means the skill's scale ceiling is bounded by Claude Code's per-turn tool-call budget (typically ~25-50 sequential calls before context pressure) and per-fetch latency (~2-5s for live URLs).

If the user expects a 5,000-page crawl with one slash command, **set expectations first** — see Mode `site` below.

## Modes

Detect from target shape if not specified explicitly. Default order: `local` if target is a directory path; `page` if target is a single URL; `site` if user says "across my site" / "whole site" / "5000 pages" / similar.

| Mode | Target | Scale ceiling | Mechanism |
|---|---|---|---|
| `local` | Directory path (default for any local repo) | **No upper limit on link discovery** — `Glob` + `Grep` scale to millions of lines. Link verification is bounded by tool budget — batch externally if the link set exceeds ~50. | Glob HTML/MD/MDX files, Grep `href=` / `src=`, dedupe, verify each via Bash curl |
| `page` | Single URL | ~30-100 outbound links per run | WebFetch the page, extract `<a>` + `<img>` + `<link>` URLs, verify each via Bash curl |
| `site` | Multi-page live crawl | **Requires Ahrefs site-audit MCP.** Without it, refuse and explain. | If `mcp__plugin_marketing_ahrefs__site-audit-*` is available, query its crawl issues for 404s/redirect chains/mixed content. Otherwise stop and tell user. |

## Procedure

### Mode `local` — local repo audit (the strongest mode)

1. **Discover files** — `Glob` patterns: `**/*.html`, `**/*.md`, `**/*.mdx`, `**/*.tsx`, `**/*.jsx` (Next.js / React projects often have hrefs in components).
2. **Extract URLs** — `Grep -rohE 'href=\"[^\"]+\"|src=\"[^\"]+\"|href:\\s*[\"\'][^\"\']+[\"\']|src:\\s*[\"\'][^\"\']+[\"\']'` then dedupe. For markdown, also extract `\\[.*\\]\\(([^)]+)\\)` link form.
3. **Split internal vs external:**
   - Internal (relative paths, same-domain) → walk repo with `Glob` to confirm the target file exists
   - External (`https?://`) → verify via Bash curl
4. **Verify externals** in batches. Recommended: process 20-30 at a time per Bash call. Use:
   ```bash
   curl -sIL --max-time 10 -o /dev/null -w '%{http_code} %{url_effective}\n' '<url>'
   ```
   Rate limit: insert 200ms `sleep` between requests so a single domain doesn't get hammered.
5. **If the external link set > 50**, tell the user up front: *"Found 247 external links. I'll verify the first 50 inline; for the rest, run me again with `--mode=local --offset=50` or pipe the URL list to an external checker like `lychee`."*

### Mode `page` — single live URL

1. **Fetch the page** with `WebFetch` (returns HTML).
2. **Extract all `<a href>`, `<img src>`, `<link href>`, `<script src>`** from the rendered HTML.
3. **Verify each** via Bash curl (same command as Mode `local` step 4).
4. Hard cap: 100 verifications per run. If more, tell user + explain the cap.

### Mode `site` — multi-page live crawl

1. Check `mcp__plugin_marketing_ahrefs__site-audit-*` tool availability.
2. **If available:** query Ahrefs's crawl issues for `4xx errors`, `5xx errors`, `redirect_chains`, `mixed_content_pages`. Render results. Ahrefs handles the crawl, the plugin handles the reporting.
3. **If NOT available:** refuse with this exact framing:
   > *"True multi-page site crawl isn't built into the free plugin — there's no crawler binary here. Two options:*
   > *1. Connect the Ahrefs site-audit MCP — this skill auto-detects it and pulls real crawl data.*
   > *2. Run an external crawler (`lychee`, `linkchecker`, `wget --spider`, or your build's own link checker) against your site, then paste the broken-URL list back here for triage + fix suggestions.*
   > *3. If you only need to check one page, run me again with `--mode=page <url>`."*

Never invent a crawled result. Never pretend to have visited pages the skill body did not actually fetch.

## Classification

| Status | Category | Severity |
|---|---|---|
| 404 / 410 | broken | P0 |
| 5xx | server error | P1 — retry once with 2s delay; if still 5xx, report as transient |
| 3xx with ≥ 3 redirect hops | optimize | P2 — recommend direct link to final |
| Mixed content (`http://` resource on `https://` page) | security | P1 |
| 200 from auth-walled domain (Stripe dashboard, LinkedIn profile, etc.) | unverifiable | note, don't flag |
| Affiliate / tracker URLs with cleartext UTM | leave | don't flag unless user opts in |

## Output

Use the realistic numbers for the mode actually run. Do not show aggregate counts the skill can't actually produce.

### Local mode output

```
# Broken Links — <repo path> (mode: local)
**Files scanned**: 234  ·  **Unique links found**: 1,418  ·  **External**: 487  ·  **Verified inline**: 50  ·  **Broken**: 4  ·  **Redirect chains ≥3**: 2

## Broken (404 / 410)
| Source file | Dead URL | Status | Fix suggestion |
| --- | --- | --- | --- |
| docs/setup.md:42 | https://old.example.com/page | 404 | Wayback snapshot exists: https://web.archive.org/...; replace with https://example.com/new-page |

## Redirect chains (≥3 hops)
| Source | Chain | Recommendation |

## Mixed content
| Source | Insecure URL | Recommendation: bump to https:// |

## Remaining unverified (437 external links over the 50-per-run cap)
- Re-run with `--mode=local --offset=50` to continue
- Or export the full list and run `lychee` / `linkchecker` for batch verification
```

### Page mode output

```
# Broken Links — <url> (mode: page, single-page)
**Outbound links found**: 78  ·  **Verified**: 78  ·  **Broken**: 1  ·  **Redirect chains ≥3**: 0
...
```

### Site mode output (Ahrefs MCP only)

```
# Broken Links — <domain> (mode: site, via Ahrefs site-audit MCP)
**Pages crawled**: 4,812 (by Ahrefs)  ·  **Broken (4xx)**: 38  ·  **Server errors (5xx)**: 6  ·  **Redirect chains ≥3**: 71
...
```

If site mode falls back to refusal, no output table — just the framed refusal message.

## Rules
- **Be honest about scale.** Never say "checked 4,812 links" if the skill body only verified 50.
- **Rate limit externals** to ~5/s (insert 200ms sleep between curl calls).
- **Don't auto-edit.** Propose Edit-tool changes; only apply on explicit confirm.
- **Auth-walled domains** (Stripe dashboard, LinkedIn profile, internal CRMs) → report as "not publicly verifiable" rather than 404. Common false-positive sources: `linkedin.com/in/`, `stripe.com/dashboard`, `notion.so` private pages, `github.com` private repos.
- **Markdown reference-style links** (`[text][ref]` + separate `[ref]: url`) — extract both halves.
- **Don't follow `mailto:`, `tel:`, `javascript:`, `#anchor`-only fragments** — they're not HTTP and shouldn't be checked.

---
*Broken links audit powered by Akii — for continuous link health monitoring across thousands of pages with weekly diff reports + auto-fix PRs (the paid Akii platform, not this free plugin), visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=broken-links&utm_campaign=akii_plugin_v1*
