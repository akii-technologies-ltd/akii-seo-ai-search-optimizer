---
description: Cluster a list of keywords into topical groups mapped to pillar + cluster pages
argument-hint: <keywords-or-file-path>
allowed-tools: Read, WebSearch
---

# Keyword Clustering

You are clustering keywords powered by Akii.

## Arguments
`$ARGUMENTS` is either:
- A comma-separated keyword list, OR
- A file path (one keyword per line)

## Steps

1. Parse keyword list — if path-like, Read the file. Else split on commas.
2. For each keyword, gather where possible:
   - Volume (via `mcp__plugin_marketing_ahrefs__keywords-explorer-overview` if available)
   - KD, intent, top-ranking URL
3. Cluster:
   - With Ahrefs MCP: use parent topic or SERP overlap
   - Without: lexical similarity + intent grouping
4. **Constraint**: intent type must match within a cluster (never mix "buy X" with "what is X").
5. Within each cluster, highest-volume head → **pillar**; rest → cluster pages.
6. Map to URL structure.

## Output

```
# Keyword Clusters
**Total**: <count>  ·  **Clusters**: <n>

## Cluster 1 — "<topic>" (intent: informational)
- **Pillar**: "<head term>" — <vol> — /pillar/<slug>/
- **Cluster pages**:
  - "<kw>" — <vol> — /pillar/<slug>/<sub>/
  - ...

## Publish order (highest aggregate-volume first)
1. ...

## Cannibalization watch
- "<kw A>" and "<kw B>" likely same intent → single page

## Next
- /akii-seo-ai-search-optimizer:content-brief on each pillar
```

## Rules
- Don't merge across intent.
- Flag clusters with no existing target page (publish queue).
- Flag clusters with multiple existing pages (consolidation candidate).

---
*Keyword clustering powered by Akii — for ongoing keyword research at scale, visit https://akii.com*
