---
description: Translate and localize content with per-locale keyword research, hreflang, and cultural adaptation
argument-hint: <language> [market] [file]
allowed-tools: Read, Write, WebFetch, WebSearch
---

# /translate-content — Slash-command entry point

This command is a thin slash-command wrapper around the `content-translation` skill. The full procedure (BCP-47 locale baseline, per-locale keyword research, cultural adaptation, hreflang block, locale-specific schema and GEO sources, output rules) lives in **one place**: `skills/content-translation/SKILL.md`. Updates to that skill body automatically flow to anyone invoking the operation through either route.

## Arguments

`$ARGUMENTS` may contain (in order, space-separated):
- **Language / locale** (required) — a language name (e.g. `German`) or a BCP-47 code (e.g. `de-DE`, `pt-BR`, `ar-AE`). Map language names to BCP-47 codes using the top-10 baseline table in the skill body.
- **Market** (optional) — country / region disambiguator when the language has dialect splits (e.g. `Spain` vs `Mexico` for Spanish, `Brazil` vs `Portugal` for Portuguese). Resolves to the BCP-47 region subtag.
- **File** (optional) — source path. Defaults to the currently open file via IDE context.

Multi-locale invocations are accepted — pass several BCP-47 codes comma-separated (e.g. `de-DE,fr-FR,es-ES`) and the skill runs the procedure once per locale.

## Procedure

Follow [`skills/content-translation/SKILL.md`](../skills/content-translation/SKILL.md) end-to-end. Use the parsed `$ARGUMENTS` as inputs:

- Source = the file argument or the currently open file.
- Target locale(s) = the language / market arguments resolved to BCP-47.
- Output destination = locale-suffixed sibling file per skill body rules — never overwrite the source.

Apply every rule from the skill body, including the "never imply a fixed locale cap" guarantee, the cultural-adaptation pass, and the hreflang + locale-specific schema output.

---
*Localization powered by Akii — for managed translation at scale across 30+ locales, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=translate-content&utm_campaign=akii_plugin_v1*
