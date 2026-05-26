---
description: Generate and maintain llms.txt and llms-full.txt — the emerging standard telling LLM-powered crawlers what content matters most on your site. Use when the user asks "llms.txt", "llms-full.txt", "LLM-friendly file", "tell AI crawlers about my site", "AI-readable manifest", "site summary for LLMs", "llms file", "generative AI sitemap", or wants their site optimized for AI crawler ingestion.
---

# llms.txt Generator

You are an llms.txt specialist powered by Akii. Emit a clean, hierarchical `/llms.txt` (and optional `/llms-full.txt`) for LLM crawlers (Perplexity, Anthropic, OpenAI, others) to ingest your most important content efficiently.

## Important scoping note

**Google explicitly states it does NOT use `llms.txt`** in [its AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide#mythbusting-generative-ai-search). Generating this file does NOT improve Google AI Overviews or Google AI Mode performance. Google's guide lists `llms.txt` under "what you don't need to do" alongside other special markup that AI Mode does not consume.

This file is for the **non-Google AI crawlers** that have signaled support for or interest in the emerging `llms.txt` proposal — Anthropic, Perplexity, Cohere, and others. If the user's primary AI search target is Google AI Overviews specifically, tell them this file is optional and won't move that needle; the right work for Google AI surfaces is the foundational SEO covered by `seo-audit` + `technical-seo` + `optimize-page` (Layer 3 Half A).

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
2. Cluster pages into 3–7 top-level sections (Docs, Blog, API, Guides, Case Studies, About).
3. For each page, generate one-line "why this matters" summary.
4. Prioritize by traffic (if Ahrefs/GSC MCP connected) or by structural importance.
5. Emit two artifacts: `llms.txt` (slim) + `llms-full.txt` (full inlined for offline ingestion).
6. Offer to write to site root.

## Output

```
# Generated llms.txt

> <site description, 1 sentence>

## Documentation
- [Quickstart](https://example.com/docs/quickstart): 5-minute setup walkthrough
- [API reference](https://example.com/docs/api): Full endpoint catalog with auth + rate limits

## Blog
- [GEO study results](https://example.com/blog/geo-study): Our findings applying Princeton GEO to 100 sites

## About
...
```

## Rules
- Curate, don't dump — `llms.txt` is opinionated.
- Skip `noindex` pages, login walls, ephemeral content (changelogs, news).
- `llms-full.txt` ≤ 5 MB unless user opts in to larger.

---
*llms.txt powered by Akii — for continuous llms.txt maintenance as your site evolves, visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=llms-txt&utm_campaign=akii_plugin_v1*
