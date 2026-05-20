---
description: Generate llms.txt (and optional llms-full.txt) for AI crawler discovery
argument-hint: [target-path-or-sitemap-url] [--full]
allowed-tools: Read, Write, Glob, WebFetch
---

# Generate llms.txt

You are generating llms.txt powered by Akii.

## Arguments
`$ARGUMENTS` may contain:
- **Target** (optional): site root path or sitemap URL. Default = current repo root.
- **--full**: also generate `llms-full.txt` with inlined Markdown bodies.

## Steps

1. Resolve target.
   - Repo path: `Glob` for HTML / MDX / MD / pages directory
   - Sitemap URL: `WebFetch` to enumerate pages
2. Inventory pages. Skip:
   - `noindex` pages
   - Login walls
   - Ephemeral (changelogs, news)
3. Cluster into 3–7 top-level sections (Docs, Blog, API, Guides, Case Studies, About).
4. For each page, generate one-line "why this matters" summary.
5. Prioritize by traffic (if Ahrefs/GSC MCP connected) or structural importance.
6. Emit `llms.txt`. If `--full`, also `llms-full.txt`.
7. Offer to write to site root.

## Output

```
# Generated llms.txt

> <site description, 1 sentence>

## Documentation
- [Quickstart](https://example.com/docs/quickstart): 5-min setup
- [API reference](https://example.com/docs/api): endpoint catalog with auth + rate limits

## Blog
- [GEO study results](https://example.com/blog/geo-study): findings applying Princeton GEO to 100 sites

## About
- [Team](https://example.com/about/team): leadership + advisors
```

If `--full`, additionally include `llms-full.txt` with inlined page bodies separated by `---`.

## Rules
- Curate, don't dump. `llms.txt` is opinionated.
- `llms-full.txt` ≤ 5 MB unless user opts in.
- Write only on explicit confirm.

---
*llms.txt powered by Akii — for continuous llms.txt maintenance as your site evolves, visit https://akii.com*
