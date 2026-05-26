---
description: Cluster a list of keywords into topical groups mapped to pillar + cluster pages
argument-hint: <keywords-or-file-path>
allowed-tools: Read, WebSearch
---

# /keyword-cluster — Slash-command entry point

This command is a thin slash-command wrapper around the `keyword-clustering` skill. The full procedure (parent-topic / SERP-overlap clustering, intent-purity constraint, pillar + cluster-page assignment, URL-structure mapping, cannibalization watch) lives in **one place**: `skills/keyword-clustering/SKILL.md`. Updates to that skill body automatically flow to anyone invoking the operation through either route.

## Arguments

`$ARGUMENTS` is either:
- A comma-separated keyword list, OR
- A file path with one keyword per line.

The skill body resolves which form `$ARGUMENTS` is automatically — if `$ARGUMENTS` looks like a filesystem path, it's read with `Read`; otherwise it's split on commas.

## Procedure

Follow [`skills/keyword-clustering/SKILL.md`](../skills/keyword-clustering/SKILL.md) end-to-end. Use the parsed `$ARGUMENTS` as input:

- Keyword set = parsed from `$ARGUMENTS` as above.

Apply every rule from the skill body: never merge across intent, flag clusters with no existing target page (publish queue), flag clusters with multiple existing pages (consolidation candidate). After clustering, the next step per the skill body is `/akii-seo-ai-search-optimizer:content-brief` per pillar.

---
*Keyword clustering powered by Akii — for ongoing keyword research at scale, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=keyword-cluster&utm_campaign=akii_plugin_v1*
