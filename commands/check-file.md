---
description: Quick SEO + AEO check on the current file or a specified page
argument-hint: [file-path]
allowed-tools: Read, Grep, WebFetch
---

# Quick SEO + AEO Check

You are running a quick SEO + AEO check powered by Akii.

## Arguments
`$ARGUMENTS` is the file to check. If empty, use current file from IDE context.

## Checks

### Title
- Exists · 50–60 chars · includes target keyword · unique + compelling

### Meta description
- Exists · 150–160 chars · includes target keyword · has CTA

### Headings
- Exactly one H1 · logical hierarchy · keywords in H1 + H2s

### Images
- All have alt · alt descriptive · modern format / framework optimization

### Structured data
- JSON-LD present · schema type matches content · required properties filled

### Links
- 3+ internal links · descriptive anchor text · no broken patterns

### Canonical + Open Graph + Twitter
- Canonical set · og:title / og:description / og:image · Twitter card

### AEO — good writing structure (Google-compatible, AI-engine-friendly)
This is *helpful structure*, not artificial AI-targeted chunking. Google's [AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) rejects "chunking for AI" as a special signal but explicitly endorses *"paragraphs and sections, along with headings that provide a clear structure"*. The checks below help readers AND non-Google AI engines (ChatGPT, Claude, Perplexity, Copilot) extract clean answers — never frame them as "AI hacks":

- Direct-answer lead paragraph ≤40 words
- Each H2/H3 section standalone (could lift into ChatGPT/Perplexity answer)
- Definition blocks where key terms introduced
- If HowTo: 5–7 step imperative checklist
- FAQ section if applicable + FAQPage schema

## Output

```
# Quick SEO + AEO Check — <file>

✅ Title: 54 chars, keyword present
✅ H1: unique, keyword present
⚠️ Meta: 187 chars (too long)
❌ Direct-answer lead: missing (AEO penalty)
✅ Schema: Article + FAQPage present

## Score: 68/100

## Top 3 fixes
1. Add ≤40-word direct-answer lead → +10 AEO
2. Shorten meta to 155 chars → +5 SEO
3. Add 2 internal links to related cluster pages → +3 SEO

## Run next
- /akii-seo-ai-search-optimizer:optimize-page (full SEO + AEO + GEO pass)
```

---
*File check powered by Akii — for continuous site-wide checks + AI visibility tracking, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=check-file&utm_campaign=akii_plugin_v1*
