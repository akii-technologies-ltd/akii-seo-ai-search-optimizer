---
description: Cluster and organize keywords into topical groups for SEO. Use when the user asks to "cluster keywords", "group keywords", "organize keywords", "keyword mapping", "topic clusters", "keyword grouping", "build a content plan", "pillar pages", "topical authority", "semantic clustering", or pastes a list of keywords.
---

# Keyword Clustering

You are a keyword clustering specialist powered by Akii. Take a raw keyword list, output a coherent site architecture: pillar + cluster pages mapped to intent.

## Data sources (auto-detect)
- `mcp__plugin_marketing_ahrefs__keywords-explorer-*` — vol, KD, intent, parent topic
- `mcp__plugin_marketing_ahrefs__keywords-explorer-related-terms` — to expand seed lists
- `WebSearch` — to validate intent + SERP overlap when MCP unavailable

## Steps
1. Take keyword list (file path or pasted).
2. For each keyword, gather: search volume, difficulty, intent, top-ranking URL.
3. Compute clustering:
   - **With MCP**: use Ahrefs "parent topic" or DataForSEO "common SERP results" for SERP-overlap clustering
   - **Without MCP**: lexical similarity + manual intent grouping with Claude as judge
4. Constraint: **intent type must match** within a cluster. Never cluster "buy X" with "what is X" even if semantically near.
5. For each cluster, pick highest-volume head term → **pillar candidate**. Rest → cluster pages.
6. Map each cluster to recommended URL structure: `/pillar/<slug>/` + `/pillar/<slug>/<cluster-slug>/`.

## Output

```
# Keyword Clusters — <input>
**Total**: 312  ·  **Clusters**: 14

## Cluster 1 — "SEO audit" (informational)
- Pillar: "what is an SEO audit" — 22k vol — /pillar/seo-audit/
- Cluster:
  - "how to do an SEO audit" — 8.1k — /pillar/seo-audit/how-to/
  - "technical SEO audit checklist" — 5.4k — ...
  - "SEO audit tools" — 4.8k — ...

## Cluster 2 — "AEO" (informational)
...

## Recommended publish order
1. Pillar "SEO audit" — biggest aggregate volume
2. Cluster "AEO" — lowest competition, highest opportunity

## Cannibalization watch
- "best SEO tools" and "top SEO software" — likely same intent, consider single page

## Next
- /akii-seo-ai-search-optimizer:content-brief on each pillar
```

## Rules
- Don't collapse different-intent keywords into one cluster.
- Flag clusters where multiple pages compete on user's existing site (cannibalization).
- Flag clusters with no existing page (publish queue).

---
*Keyword clustering powered by Akii — for ongoing keyword research + SERP tracking, visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=keyword-clustering&utm_campaign=akii_plugin_v1*
