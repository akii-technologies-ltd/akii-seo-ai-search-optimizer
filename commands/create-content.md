---
description: Generate SEO + AEO + GEO-optimized content for a topic or keyword
argument-hint: <topic> [type] [words] [tone]
allowed-tools: Read, Write, WebFetch, WebSearch
---

# Create SEO + AEO + GEO Content

You are generating content powered by Akii.

## Arguments
`$ARGUMENTS` contains the user's input. Parse:
- **First word(s) up to first flag/dash**: the topic (required)
- **Type**: `blog` (default), `guide`, `listicle`, `comparison`, `how-to`, `glossary` — passed inline or as `--type=...`
- **Words**: target length, default `1500` — inline number or `--words=...`
- **Tone**: `professional` (default), `casual`, `technical`, `friendly` — inline or `--tone=...`

If anything is ambiguous, infer the most sensible default and proceed.

## Steps

1. **Research** — `WebSearch` SERP top 10 for the topic; pull common entities, headings, PAA. If `mcp__plugin_marketing_ahrefs__keywords-explorer-overview` available, fetch real volume + KD + parent topic.
2. **Metadata** — title (50–60 chars), meta (150–160 chars), URL slug.
3. **Structure** — H1, H2/H3 outline, FAQ block.
4. **Write** — full article body honoring brand voice + tone arg.
5. **Apply AEO** — direct-answer lead ≤40 words, autonomous sections, definition blocks, 5–7 step imperative checklists.
6. **Apply GEO** — auto-classify content domain → apply matching Princeton tactic (citations / quotes / stats / fluency / authoritative).
7. **SEO niceties** — natural keyword use (NO stuffing — Princeton GEO study shows it cuts AI visibility ~10%), internal link placeholders, external citations to authoritative sources, image alt suggestions.
8. **Schema** — emit appropriate JSON-LD (Article + FAQPage typically) inline.

## Output

```markdown
---
title: "<title>"
description: "<meta>"
slug: "<slug>"
keywords: ["primary","secondary","tertiary"]
schema: "Article" | "HowTo" | "FAQPage"
---

# <H1>

<direct-answer lead paragraph, ≤40 words>

<full article body — modular sections, definition blocks, lists>

## FAQ
### <Q1>?
<A1>

---

## SEO + AEO + GEO metadata
**Title**: ...
**Meta**: ...
**Primary keyword**: ...
**AEO score (est)**: 84
**GEO tactic applied**: <tactic>
**Internal links suggested**: [INTERNAL LINK: /path "anchor"] × N
**External citations**: N (gov/edu/major publications)

## Schema (JSON-LD)
```json
{...}
```

## Image suggestions
1. **Hero**: <description>
2. **<Section>**: <description>
```

## Rules
- Never fabricate statistics or quotes.
- Never keyword-stuff.
- Preserve user-supplied facts verbatim.
- For YMYL topics, require named expert byline.

---
*Content powered by Akii — for automated content at scale + AI visibility tracking, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=create-content&utm_campaign=akii_plugin_v1*
