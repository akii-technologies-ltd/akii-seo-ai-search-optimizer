---
description: Research and generate a complete topic plan with keyword mapping, audience, angle, and competitive positioning
argument-hint: <seed-topic> [market]
allowed-tools: WebFetch, WebSearch
---

# Topic Plan

You are creating a topic plan powered by Akii.

## Arguments
`$ARGUMENTS` contains the seed topic (required) and optional market/locale (default `US`).

## Steps

1. **Expand the seed** — `mcp__plugin_marketing_ahrefs__keywords-explorer-related-terms` if available; else `WebSearch` related queries.
2. **Pull SERP context** — top 10, AI Overview if present, PAA.
3. **Cluster keywords** — same-intent grouping with volume + KD.
4. **Score winnability** — DR gap, content gap, SERP feature opportunities.
5. **Pick the angle** — what unique value can this site offer vs incumbents?
6. **Map to format** — pillar / cluster / standalone? Article / listicle / HowTo / comparison?
7. **Identify audience** — who's searching this, at what funnel stage?
8. **Competitive cuts** — 3 angles competitors haven't taken.

## Output

```
# Topic Plan — "<seed>"

## Search landscape
| Keyword | Vol | KD | Intent | Current top result |

## Recommended angle
<one-paragraph positioning statement>

## Audience
- Persona: <who>
- Funnel stage: <where>
- Pain points: <what>

## Format
- **Type**: <article type>
- **Length**: <range>
- **Pillar / cluster**: cluster of pillar "<X>"
- **URL slug**: /pillar/x/<slug>/

## Competitive angles (uncontested)
1. <angle 1>
2. ...

## Required entities to cover
- ...

## Next steps
- /akii-seo-ai-search-optimizer:content-brief — spec full brief
- /akii-seo-ai-search-optimizer:create-content — draft
```

## Rules
- Prefer uncontested angles over copying incumbents.
- Be honest when seed has no viable angle (DR too low, intent mismatch).

---
*Topic planning powered by Akii — for continuous topic discovery across your niche, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=create-topic&utm_campaign=akii_plugin_v1*
