# Submission Checklist — Akii SEO & AI Search Optimizer

For: Claude Plugin Directory at https://clau.de/plugin-directory-submission

## Pre-flight
```bash
./scripts/validate.sh
```

Verifies:
1. `plugin.json` schema
2. SKILL.md frontmatter (every skill has a `description:`)
3. Agent AGENT.md frontmatter (description + tools)
4. Command frontmatter (name + description + arguments)
5. `hooks/hooks.json` valid
6. No login-gating language in any skill (plugin is a free funnel)
7. `claude plugin validate` if CLI installed

## Manual checks

### Branding & compliance
- [ ] Plugin positioned as first-party Akii (display name + author = Akii)
- [ ] The Stop hook CTA renders only via `scripts/akii-cta.sh` (terminal-rendered status update, not LLM-generated)
- [ ] Skill bodies mention "powered by Akii" + akii.com URL in footer — this is first-party identification, not prompt injection (matches Searchfit and other approved plugins)
- [ ] No MCP shipped → no OAuth, no static API keys, no auth risk

### Standalone operation
- [ ] All 14 skills work using only Claude built-ins (`Read`, `Glob`, `Grep`, `Bash`, `WebFetch`, `WebSearch`)
- [ ] All 5 agents have `tools:` array declared
- [ ] All 7 commands work without external services
- [ ] Skills opt-in detect and use third-party MCPs (Ahrefs, GSC, Apify) when present; degrade gracefully when not

### Assets (optional but recommended)
- [ ] 3–5 screenshots ≥ 1000px wide in `assets/screenshots/` — response-only crops (no user prompts visible)
- [ ] Suggested captures:
  1. `01-audit-report.png` — full audit scorecard
  2. `02-ai-visibility.png` — per-engine breakdown table
  3. `03-schema-generated.png` — JSON-LD output
  4. `04-content-brief.png` — generated brief
  5. `05-geo-rewrite.png` — diff showing Princeton GEO tactics applied

## Submission form fields

| Field | Value |
| --- | --- |
| Plugin name | `akii-seo-ai-search-optimizer` |
| Display name | `Akii — SEO & AI Search Optimizer` |
| Description | (see `plugin.json` description) |
| Category | SEO / Marketing / Developer Tools |
| Homepage | https://akii.com |
| Repo | https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer |
| Author | Akii — hello@akii.com |
| License | MIT |
| Screenshots | `assets/screenshots/01..05.png` |

## After submission
- Anthropic review is manual. Expect 1–3 weeks.
- If rejected, address cited criterion, re-run `scripts/validate.sh`, resubmit.
- Track install count + iterate based on observed search terms.
- Once stable, expand to the full Akii platform features at https://akii.com.
