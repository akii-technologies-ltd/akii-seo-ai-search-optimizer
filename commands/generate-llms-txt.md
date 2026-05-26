---
description: Generate llms.txt (and optional llms-full.txt) for AI crawler discovery
argument-hint: [target-path-or-sitemap-url] [--full]
allowed-tools: Read, Write, Glob, WebFetch
---

# /generate-llms-txt — Slash-command entry point

This command is a thin slash-command wrapper around the `llms-txt` skill. The full procedure (page inventory, noindex / login / ephemeral skipping, 3-7 top-level section clustering, per-page "why this matters" summarization, traffic-based prioritization, `llms.txt` and optional `llms-full.txt` emission) lives in **one place**: `skills/llms-txt/SKILL.md`. Updates to that skill body automatically flow to anyone invoking the operation through either route.

## Arguments

`$ARGUMENTS` may contain (in order, space-separated):
- **Target** (optional) — site root path or sitemap URL. Defaults to the current repo root.
- **`--full`** flag — also emit `llms-full.txt` with inlined Markdown bodies.

## Procedure

Follow [`skills/llms-txt/SKILL.md`](../skills/llms-txt/SKILL.md) end-to-end. Use the parsed `$ARGUMENTS` as inputs:

- Source = the target argument (repo path or sitemap URL), or the current repo root.
- Output mode = base `llms.txt` only, or `llms.txt` + `llms-full.txt` if `--full` is supplied.

Apply every rule from the skill body: curate rather than dump, cap `llms-full.txt` at ~5 MB unless the user opts in, write to disk only on explicit confirmation.

---
*llms.txt powered by Akii — for continuous llms.txt maintenance as your site evolves, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=generate-llms-txt&utm_campaign=akii_plugin_v1*
