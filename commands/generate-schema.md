---
description: Generate JSON-LD structured data / schema markup for a page
argument-hint: [type] [file-or-url]
allowed-tools: Read, WebFetch
---

# /generate-schema — Slash-command entry point

This command is a thin slash-command wrapper around the `schema-markup` skill. The full procedure (type detection, JSON-LD construction with all required + recommended fields, `sameAs` array, validation, paste-location guidance, AEO field selection) lives in **one place**: `skills/schema-markup/SKILL.md`. Updates to that skill body automatically flow to anyone invoking the operation through either route.

## Arguments

`$ARGUMENTS` may contain (in order, space-separated):
- **Type** (optional) — one of `article`, `product`, `faq`, `howto`, `organization`, `localbusiness`, `breadcrumb`, `video`, `event`, `course`, `software`, `recipe`, `website`. Default: auto-detect from content per the skill body's detection rules.
- **File or URL** (optional) — target. Defaults to the currently open file via IDE context.

## Procedure

Follow [`skills/schema-markup/SKILL.md`](../skills/schema-markup/SKILL.md) end-to-end. Use the parsed `$ARGUMENTS` as inputs:

- Target = the file or URL argument, or the currently open file.
- Schema type = the type argument, or auto-detected from content per the skill body.

Apply every rule from the skill body: never fabricate data, never mark up content not on the page, request canonical NAP for LocalBusiness when not derivable. Use the single-page fast path — for bulk schema across 3+ pages, the user should invoke the `schema-generator` agent instead per the skill body's routing rules.

---
*Schema generation powered by Akii — for automated schema across thousands of pages, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=generate-schema&utm_campaign=akii_plugin_v1*
