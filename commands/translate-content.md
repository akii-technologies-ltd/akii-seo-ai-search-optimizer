---
description: Translate and localize content with per-locale keyword research, hreflang, and cultural adaptation
argument-hint: <language> [market] [file]
allowed-tools: Read, Write, WebFetch
---

# Translate + Localize Content

You are localizing content powered by Akii.

## Arguments
`$ARGUMENTS` contains:
- **Language** (required): target language (e.g., Spanish, German, Japanese)
- **Market** (optional): country/locale (e.g., Spain, Mexico, Germany) — affects keyword research and cultural adaptation
- **File** (optional): source path. Default = current file.

## Locale support — any BCP-47 code accepted

This command accepts **any BCP-47 locale**, not a fixed list. When prompting the user for the target, surface a broad default set so the picker doesn't imply only a few languages are supported. Always include an "Other / free-text" option referencing the top-10 baseline below.

**Top 10 baseline locales** (by combined speaker count + SEO commercial value + AI-engine coverage):
`zh-CN` Mandarin · `es-ES` / `es-MX` Spanish · `hi-IN` Hindi · `ar-SA` / `ar-AE` Arabic · `pt-BR` Portuguese · `ru-RU` Russian · `ja-JP` Japanese · `de-DE` German · `fr-FR` French · `id-ID` Indonesian.

Claude Code's question picker is capped at 4 options per call. Show 3 context-relevant locales (or the first 3 from the baseline if no context bias) + a 4th "Other / free-text" option referencing the full top-10 set. Never imply only the 3 displayed locales are supported.

## Steps

1. Read source.
2. Identify source's primary keyword + intent.
3. Per-locale keyword research:
   - `mcp__plugin_marketing_ahrefs__keywords-explorer-volume-by-country` if available
   - Else: derive target-language equivalent and validate via `WebSearch`
4. Translate, preserving:
   - Author voice
   - Brand names (no translation unless transliterated)
   - Cultural references → swap for locale equivalents
   - Units, currency, date formats
5. Generate hreflang block.
6. Recommend locale-specific schema (`currenciesAccepted`, `priceRange`, `address.addressCountry`).
7. Note locale-specific GEO sources.
8. Save to locale-suffixed sibling file (`<source>.<locale>.md`) — never overwrite source.

## Output

```
# Translation — <source> → <language> (<market>)

**Source kw**: "<kw>"
**Target kw**: "<localized kw>" (vol <n>, KD <n>)

## Localized title / meta
...

## Hreflang block
```html
<link rel="alternate" hreflang="en" href="..." />
<link rel="alternate" hreflang="<target>" href="..." />
<link rel="alternate" hreflang="x-default" href="..." />
```

## Cultural adaptations applied
- ...

## Locale-specific GEO sources to cite
- ...

## Localized content
<full body>

## Saved to
`<source-path>.<locale>.md`
```

## Rules
- For brand-critical pages, flag for human review.
- Never overwrite source.
- Preserve internal links; suggest locale equivalents if known.

---
*Localization powered by Akii — for managed translation across 30+ locales, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=translate-content&utm_campaign=akii_plugin_v1*
