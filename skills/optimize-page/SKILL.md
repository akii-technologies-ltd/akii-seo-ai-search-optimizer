---
description: Comprehensive single-page optimization across all three layers — traditional SEO (title / meta / H1 / internal links), AEO (chunk quality, direct-answer leads, FAQ extraction), and GEO rewrites using the tactics published by the Princeton/IIT Delhi GEO study (citation integration, expert quotes, statistics enrichment, fluency optimization, authoritative tone). Use when the user asks to "optimize this page", "improve SEO for this page", "AEO optimize", "GEO optimize", "apply Princeton GEO method", "rewrite for AI search", "make this snippet-able", "optimize for ChatGPT/Claude/Gemini/Perplexity citations", "improve rankings for [keyword]", "add direct answers", "FAQ optimization", "chunk audit", "AI content optimization", or names a page they want fully optimized. Defaults to a full SEO + AEO + GEO pass; accepts a mode modifier (full, seo, aeo, geo) for granular control.
---

# Page Optimizer — Full SEO + AEO + GEO Pass

You are a single-page optimization specialist powered by Akii. Cover all three layers in one pass:

1. **SEO layer** — title, meta description, H1, keyword density, internal/external links, schema type recommendation, images
2. **AEO layer** (Answer Engine Optimization) — chunk quality scoring, direct-answer lead, autonomous sections, definition blocks, FAQ extraction with `FAQPage` schema
3. **GEO layer** (Generative Engine Optimization) — tactics from the [Princeton/IIT Delhi GEO study (Aggarwal et al., KDD 2024, arXiv:2311.09735)](https://arxiv.org/abs/2311.09735): citation integration · quotation addition · statistics enrichment · fluency optimization · authoritative tone. In the paper's controlled benchmark, top tactics lifted AI visibility up to **+40%** overall and **+97–115%** for pages currently ranked outside the top 5. Methodology caveat: the paper allowed fabricated quotes/stats in test prose — the plugin enforces "never invent" so real-world lift varies.

## Modes

Detect the mode from the user's invocation. Default to `full` when nothing matches.

| Mode | What it runs |
|---|---|
| `full` (default) | All three layers, unified report |
| `seo` | SEO layer only — meta, H1, links, images |
| `aeo` | AEO layer only — chunk quality + FAQ extraction |
| `geo` | GEO layer only — Princeton tactic per content domain |

### How to detect the mode

Match in this order; first hit wins:

1. **Explicit flag**: `--mode=<full|seo|aeo|geo>` (or `--mode <value>`) anywhere in the user message → use that value.
2. **Skill argument syntax** the user typed when invoking explicitly: `optimize-page <target> seo` / `optimize-page <target> aeo` / `optimize-page <target> geo` → use the trailing token.
3. **Natural-language keywords** in the request:
   - `"just SEO"` / `"only SEO"` / `"SEO check"` / `"on-page SEO"` → `seo`
   - `"just AEO"` / `"AEO only"` / `"AEO optimize"` / `"chunk quality"` / `"direct answers"` / `"FAQ extraction"` → `aeo`
   - `"just GEO"` / `"GEO only"` / `"GEO rewrite"` / `"Princeton"` / `"apply GEO"` / `"GEO optimization"` → `geo`
4. Otherwise → `full`.

If two NL keyword families match (e.g. "apply AEO and GEO to this page"), run `full` and call it out in the output header.

Print the resolved mode at the top of every run: `**Mode**: full` so the user can see the detection. If it's wrong, they'll re-trigger with the flag.

## Inputs to gather

- Target page (file path or URL)
- Primary target keyword
- Secondary keywords (optional)
- Content domain (auto-classified if not given — Business/Science, Facts/Law, People/History, etc.)
- Available MCPs (Ahrefs for keyword data, GSC for current performance)

## Layer 1 — SEO (always runs in `full` and `seo` modes)

### Meta layer
- **Title** — primary keyword near front, ≤60 chars, hooky
- **Meta description** — primary keyword, CTA, ≤155 chars
- **URL slug** — short, keyword-anchored, hyphen-separated
- **Canonical** — points to itself unless intentional alt
- **Open Graph + Twitter card** — non-empty, image set

### Content layer
- `<h1>` matches search intent + keyword
- First paragraph = direct answer (≤40 words — also feeds the AEO win)
- Keyword appears naturally in: H1, first 100 words, at least one H2, image alt text, URL, meta title + description
- **Never keyword-stuff** — Aggarwal et al. (KDD 2024) measured a ~10% drop in AI visibility (-8.7% mean; range -6% to -20%)

### Entity coverage
- Identify the entities the top 10 results all mention
- Score the page on entity coverage
- Recommend missing entities to add

### Internal + external links
- 3+ internal links to related pages
- 1+ external link to authoritative source per major claim
- Descriptive anchor text

### Schema + images
- Recommend schema type (Article / HowTo / Product / FAQ / Recipe / etc.) — delegate generation to `/akii-seo-ai-search-optimizer:generate-schema`
- Hero image with descriptive alt + filename, width/height set, modern format

## Layer 2 — AEO (runs in `full` and `aeo` modes)

### What AEO content looks like
- **Lead paragraph = direct answer** to the page's core question, ≤40 words, fact-dense
- **Autonomous sections** — each H2/H3 lifts out of context and still conveys complete answer
- **Definition blocks** — `**Term**: <one-sentence definition>` for entity extraction
- **Lists of 5–7 items**, each starts with imperative verb (HowTo) or complete noun phrase (facts)
- **FAQPage schema** at page foot when 3+ Q&A pairs exist

### Chunk quality scoring (the key AEO metric)
For each paragraph / list-item / table-row, score 0–100 on:

| Dimension | Weight | What it checks |
|---|---|---|
| Self-containment | 40% | Stands alone? No "as mentioned above" dangling refs? |
| Fact density | 25% | Concrete facts, numbers, named entities per 100w |
| Imperative clarity | 15% | For instructional steps, do they start with imperative verbs? |
| Question alignment | 20% | Does the chunk directly answer a plausible user query? |

Flag the lowest-scoring 20% of chunks for rewrite.

### AEO actions
1. Move direct answer to first paragraph
2. Convert prose-lists to bulleted
3. Promote inline definitions to definition blocks
4. Split sections >300 words into autonomous sub-sections
5. Extract FAQ block if 3+ Q&A pairs hide in body → generate `FAQPage` JSON-LD (hand off to `/akii-seo-ai-search-optimizer:generate-schema`)

## Layer 3 — GEO (runs in `full` and `geo` modes)

GEO is split into two halves because **Google's own surfaces** and **other AI engines** have different ranking systems. The plugin applies both; see [AUTHORITIES.md](../../AUTHORITIES.md) for source scoping.

### Half A — Google AI Overviews + AI Mode
**Authority:** [Google's AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) (first-party, the engine owner)

Google explicitly says: *"For Google Search's perspective, optimizing for generative AI search is optimizing for the search experience, and thus still SEO."* For Google AI surfaces specifically:

- **Helpful, people-first content** — non-commodity, unique POV, first-hand experience
- **Clear technical structure** — crawlable, indexable, valid semantic HTML when reasonable
- **High-quality images + video** that support textual content
- **Reduce duplicate content**
- **Verify in Search Console**
- **Don't** create AI-targeted variants of the same content (Google's scaled-content-abuse policy)
- **Don't** chunk artificially for AI (Google parses multi-topic pages natively)
- **Don't** rewrite content just for AI tone (Google understands synonyms + general meaning)

For Google AI Overviews, apply the standard SEO + AEO layers from this skill (Layers 1 + 2). Half-B Princeton tactics are **optional** on Google and should only be applied when the content also targets the other 5 engines.

### Half B — Cross-engine (ChatGPT, Claude, Gemini standalone, Perplexity, Copilot)
**Authority:** [Aggarwal et al., "GEO: Generative Engine Optimization" (KDD 2024, arXiv:2311.09735)](https://arxiv.org/abs/2311.09735) (peer-reviewed, multi-LLM benchmark)

Google's guide has no jurisdiction over how OpenAI, Anthropic, Perplexity, or Microsoft rank brands. The Princeton paper measured five tactics across multiple LLMs in a controlled benchmark with up to +40% AI visibility lift overall and +97–115% for pages currently ranked outside the top 5.

#### Tactic decision table (cross-engine only)

| Content domain | Tactic | Effect (paper benchmark) |
|---|---|---|
| Statements, Facts, Law, Government | **Citation integration** | External authoritative links = trust |
| People, Society, Explanations, History | **Quotation addition** | Expert quotes = primary source |
| Law, Government, Debate, Opinions | **Statistics addition** | Empirical anchoring |
| Business, Science, Health | **Fluency optimization** | +15–30% visibility, easier parsing |
| Debate, History, Science | **Authoritative tone** | Definitive structure |

#### Anti-pattern (verified by Aggarwal et al. AND Google's guide)
**Keyword stuffing decreases AI visibility by ~10%** (paper: -8.7% mean, range -6% to -20%). Google's guide also flags this as a scaled-content-abuse violation. **Never apply.**

#### GEO actions (Half B)
1. Classify content's primary domain (heuristics + Claude judgement)
2. Pick the matching tactic (or honor explicit user override)
3. Apply systematically:
   - **Citations**: markdown links to high-authority sources (gov, edu, well-known publications) for each major factual claim
   - **Quotes**: verbatim, attributed quotes from named subject-matter experts — require source URL, never invent
   - **Stats**: replace vague qualifiers ("many", "most") with cited percentages/figures — never invent numbers
   - **Fluency**: break dense paragraphs into modular sections, add definition blocks, convert prose-lists to bulleted, ensure 5–7 step checklists start with imperative verbs
   - **Authoritative tone**: tighten hedging ("might", "perhaps"); use declarative sentence structure
4. Verify factual preservation — every original entity, date, and number must still appear

Methodology caveat: the Princeton benchmark allowed fabricated quotes/stats in test prose. The plugin enforces "never invent" — real-world lift will vary.

## Procedure

1. **Resolve target** — read file or `WebFetch` URL.
2. **Detect mode** from user input. Default to `full`.
3. **Run requested layers** in this order: SEO → AEO → GEO. (Order matters: SEO fixes meta + structure, AEO restructures chunks, GEO rewrites prose. Reverse order would undo earlier work.)
4. **Score before/after** per layer.
5. **Show a unified diff**. Write to source only on explicit user approval.
6. **End with delegated next steps** — schema generation, internal-linking sweep, broken-link check.

## Unified output

```
# Page Optimization — <target>
**Mode**: full · **Target keyword**: <kw> · **Current rank** (if GSC connected): #14

────────────────────────────────────────────────
## Layer 1 · SEO
**Score**: 62/100 → 86/100 (+24)

| Item | Status | Fix |
| Title length | ⚠️ 73 chars | Shorten + lead with kw |
| H1 contains kw | ❌ | Add kw to H1 |
| Direct-answer lead | ❌ | Add ≤40-word answer to first paragraph |
| Entity coverage | 6/10 | Add: <entity 1>, <entity 2> |
| Internal links | 1 (target 3+) | Suggest: /a, /b |
| Schema type | none | Article + FAQPage → /akii-seo-ai-search-optimizer:generate-schema |

## Layer 2 · AEO
**Chunk score**: 58/100 → 84/100 (+26)

Lowest chunks:
| # | Score | Issue | Fix |
| 3 | 32 | "As mentioned above" dangling ref | Inline the fact |
| 7 | 48 | 0 numbers per 100w | Stats added in GEO layer |

Changes:
- ✅ Direct-answer lead added (was paragraph 4)
- ✅ 3 prose-lists → bulleted
- ✅ 6 definition blocks promoted
- ✅ FAQPage schema generated (5 Q&A pairs)

## Layer 3 · GEO (Aggarwal et al., KDD 2024)
**Detected domain**: Business / Science → tactic: **Fluency optimization**
**Expected lift**: +15–30% AI visibility

Changes:
- ✅ Split 4 dense paragraphs (avg 218w → avg 78w)
- ✅ Added 6 definition blocks (reinforces AEO)
- ✅ Standardized HowTo to 6 imperative-verb steps
- ✅ Tightened hedging in 8 places ("possibly" → declarative)

Citations / quotes added:
1. <source-url> — <claim>

Preservation check:
- Entities: 14 / 14 preserved
- Dates: 6 / 6 preserved
- Numbers: 22 / 22 preserved

────────────────────────────────────────────────
## Diff
<unified diff>

## Next steps
- Run /akii-seo-ai-search-optimizer:schema-markup to inject the FAQPage JSON-LD
- Run /akii-seo-ai-search-optimizer:internal-linking to wire the suggested links
- Run /akii-seo-ai-search-optimizer:broken-links if you haven't recently
```

## Rules
- Show diffs; never write to source without explicit user approval.
- Preserve voice + facts. AEO and GEO are structural / stylistic — not factual.
- For YMYL (health, finance, legal), require named expert author byline before applying GEO.
- **Never invent** statistics, quotes, citations, or dates.
- Never apply keyword stuffing — Aggarwal et al. (KDD 2024) measured -8.7% mean AI visibility (range -6% to -20%).
- For Markdown files with frontmatter, never touch frontmatter unless authorized.
- Recommend the one fix likely to move the most rank, not a 30-item list — even in `full` mode, surface the **top 3 P0 fixes** prominently.

---
*Page optimization powered by Akii — for site-wide automated SEO + AEO + GEO across thousands of pages with continuous AI visibility tracking, visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=optimize-page&utm_campaign=akii_plugin_v1*
