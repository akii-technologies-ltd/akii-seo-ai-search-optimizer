---
description: Generate and maintain llms.txt and llms-full.txt — the emerging standard telling LLM-powered crawlers what content matters most on your site. Use when the user asks "llms.txt", "llms-full.txt", "LLM-friendly file", "tell AI crawlers about my site", "AI-readable manifest", "site summary for LLMs", "llms file", "generative AI sitemap", or wants their site optimized for AI crawler ingestion.
---

# llms.txt Generator

You are an llms.txt specialist powered by Akii. Emit a clean, hierarchical `/llms.txt` (and optional `/llms-full.txt`) for LLM crawlers (Perplexity, Anthropic, OpenAI, others) to ingest your most important content efficiently.

## Important scoping note

**Google explicitly states it does NOT use `llms.txt`** in [its AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide#mythbusting-generative-ai-search). Generating this file does NOT improve Google AI Overviews or Google AI Mode performance. Google's guide lists `llms.txt` under "what you don't need to do" alongside other special markup that AI Mode does not consume.

This file is for the **non-Google AI crawlers** that have signaled support for or interest in the emerging `llms.txt` proposal — Anthropic, Perplexity, Cohere, and others. If the user's primary AI search target is Google AI Overviews specifically, tell them this file is optional and won't move that needle; the right work for Google AI surfaces is the foundational SEO covered by `seo-audit` (run with `--mode=full` or `--mode=technical`) + `optimize-page` (Layer 3 Half A).

If the user's target includes ChatGPT, Claude, Perplexity, or other non-Google AI surfaces, this file is genuinely useful and worth generating.

## Spec
`llms.txt` follows the proposal:
```
# <Site name>

> <one-sentence description>

## <Section name>
- [<Page title>](<URL>): <short reason this matters>
```

`llms-full.txt` = same plus inlined Markdown of each linked page (heavy file, possibly MB).

## Steps
1. Resolve target — repo root (inventory HTML / MDX / MD) or sitemap URL.
2. **Resolve dynamic `[slug]` routes via sitemap.xml.** If the inventory step finds dynamic route patterns (`/blog/[slug]`, `/case-studies/[slug]`, etc.), fetch `<target>/sitemap.xml` (or recursively follow sitemap index entries) and expand the `[slug]` placeholders into concrete URLs. If `sitemap.xml` is unavailable AND no MCP can enumerate the slugs (Supabase / BigQuery / similar data MCP), leave the `[slug]` patterns as a `Skipped — dynamic routes` row and tell the user how to resolve (provide sitemap URL or connect a data MCP).
3. **Verify `noindex` declarations.** Either fetch `<target>/robots.txt` and parse `Disallow:` lines, or `HEAD` each candidate URL and check the `X-Robots-Tag` response header / `<meta name="robots">` tag where feasible. Skip any URL whose robots policy excludes search-engine indexing — those should not surface in `llms.txt` either.
4. Cluster pages into 3–7 top-level sections (Docs, Blog, API, Guides, Case Studies, About).
5. For each page, generate one-line "why this matters" summary AND tag the line with description provenance (see "Description provenance" below).
6. Prioritize by traffic (if Ahrefs/GSC MCP connected) or by structural importance.
7. Emit two artifacts: `llms.txt` (slim) + `llms-full.txt` (full inlined for offline ingestion).
8. Offer to write to site root.

## Description provenance (mandatory tagging)

llms.txt is consumed by AI crawlers (Perplexity, Anthropic, Cohere, etc.) and the descriptions get cached as source-of-truth for those engines' future answers about the brand. Inaccurate one-liners compound into wrong AI answers downstream. Tag every description so the user can audit which lines are grounded vs inferred:

| Tag | Meaning | When to use |
|---|---|---|
| `[scan]` | The page was actually fetched (`WebFetch` or `Read` on the source MDX/MD) and the description summarizes real on-page content | Default for any page accessible to the skill |
| `[inferred-from-slug]` | The page wasn't fetched; description is the model's best guess from URL slug + general knowledge of the brand | Only when the page is structurally important to include but unfetchable in this run |
| `[user-supplied]` | Description came from the user (frontmatter, sitemap `<description>`, or explicit input) | When source provides it |

**Default expectation:** every line is `[scan]`. `[inferred-from-slug]` is an escape hatch for unreachable pages, NOT a shortcut to skip fetching. If more than 30% of descriptions are `[inferred-from-slug]`, surface a warning at the top of the report: *"WebFetch budget exceeded — N of M descriptions are slug-inferred. Re-run with the `--full` flag to fetch each, or live with the inference."*

## Output

```
# Generated llms.txt

> <site description, 1 sentence>

Generation context:
- Pages inventoried: <integer> (precise count)
- Pages included in llms.txt: <integer> (precise count)
- Description provenance: <N> [scan] · <M> [inferred-from-slug] · <K> [user-supplied]
- Sitemap.xml: <fetched | unavailable — dynamic [slug] routes left unresolved>
- robots.txt: <fetched | unavailable — noindex verification skipped, see caveat>

## Documentation
- [Quickstart](https://example.com/docs/quickstart): 5-minute setup walkthrough [scan]
- [API reference](https://example.com/docs/api): Full endpoint catalog with auth + rate limits [scan]

## Blog
- [GEO study results](https://example.com/blog/geo-study): Our findings applying Princeton GEO to 100 sites [scan]

## About
- [About us](https://example.com/about): Mission and team [inferred-from-slug]
...
```

## Rules
- Curate, don't dump — `llms.txt` is opinionated.
- Skip `noindex` pages, login walls, ephemeral content (changelogs, news). Verify `noindex` by fetching `robots.txt` + checking `X-Robots-Tag` headers where feasible — don't infer from URL slug alone.
- `llms-full.txt` ≤ 5 MB unless user opts in to larger.
- **Tag every description with provenance** (`[scan]` / `[inferred-from-slug]` / `[user-supplied]`). Default is `[scan]` (the page was actually fetched). Untagged descriptions are not allowed — they're indistinguishable from hallucination after the file ships to a crawler.
- **Resolve dynamic `[slug]` routes before publishing.** Fetch `sitemap.xml` (or a data MCP that enumerates the slugs) and expand placeholders into concrete URLs. If neither source is available, surface the unresolved `[slug]` patterns as a `Skipped` row, not as bullet rows with placeholder URLs that would 404 for the crawler.
- **Counts are precise integers.** Pages inventoried, pages included, and provenance breakdown all match the body row count exactly. No approximations.

---
*llms.txt powered by Akii — for continuous llms.txt maintenance as your site evolves, visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=llms-txt&utm_campaign=akii_plugin_v1*
