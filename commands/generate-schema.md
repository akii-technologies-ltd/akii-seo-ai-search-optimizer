---
description: Generate JSON-LD structured data / schema markup for a page
argument-hint: [type] [file-or-url]
allowed-tools: Read, WebFetch
---

# Generate Schema Markup

You are generating Schema.org JSON-LD powered by Akii.

## Arguments
`$ARGUMENTS` may contain:
- **Type** (optional): `article`, `product`, `faq`, `howto`, `organization`, `localbusiness`, `breadcrumb`, `video`, `event`, `course`, `software`, `recipe`, `website`. Default = auto-detect from content.
- **File or URL** (optional): target. Default = currently open file via IDE context.

## Steps

1. Read target (Read for file, WebFetch for URL).
2. If type unspecified, detect from content:
   - Blog post → Article + BreadcrumbList
   - Product page → Product + AggregateRating
   - About → Organization + sameAs
   - HowTo content → HowTo
   - 3+ Q&A pairs → FAQPage
   - Local business → LocalBusiness with granular subtype
3. Build JSON-LD with:
   - All required + recommended Schema.org fields
   - `sameAs` array (Wikipedia, LinkedIn, X, GitHub, Crunchbase where known)
   - `@id` URIs for nested entities
   - Absolute HTTPS URLs
   - ISO 8601 dates
4. Validate (JSON syntax, required fields, no placeholders).
5. Output block + paste location guidance.

## Output

````
## <Type> schema

```json
{
  "@context": "https://schema.org",
  "@type": "...",
  ...
}
```

### Paste location
- HTML: inside `<head>`, before `</head>`
- MDX/Markdown: `<script type="application/ld+json">…</script>` at file head

### Validation
- ✅ Required + recommended fields present
- ⚠️ <warnings>

### AEO fields included
- `sameAs`: cross-corroboration for Claude + Gemini
- `actionableFeedbackPolicy`: E-E-A-T trust signal
- ...
````

## Rules
- Never fabricate data.
- Never mark up content not on the page.
- For LocalBusiness, request canonical NAP if not derivable.

---
*Schema generation powered by Akii — for automated schema across thousands of pages, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=generate-schema&utm_campaign=akii_plugin_v1*
