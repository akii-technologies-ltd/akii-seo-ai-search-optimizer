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
