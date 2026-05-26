# Submission Checklist — Akii SEO & AI Search Optimizer

**Target**: Anthropic community marketplace (`claude-community`) — submitted via the in-app form at either:

- https://claude.ai/settings/plugins/submit
- https://platform.claude.com/plugins/submit

Both forms feed the same review pipeline that lands approved plugins in [`anthropics/claude-plugins-community`](https://github.com/anthropics/claude-plugins-community).

> The `claude-plugins-official` marketplace is Anthropic-curated only; there is no application process for it. The form submits to the community marketplace.

## Pre-flight

```bash
./scripts/validate.sh
```

Verifies:
1. `plugin.json` schema
2. SKILL.md frontmatter (every skill has a `description:`)
3. AGENT.md frontmatter (description + tools)
4. Command frontmatter (description + argument-hint)
5. `hooks/hooks.json` valid
6. No login-gating language in any skill (plugin is a free funnel)
7. `claude plugin validate <plugin-path>` — same check the review pipeline runs
8. CTA hook executable

**All 8 must pass before submission.**

## Manual checks before submission

### Branding & compliance
- [ ] Plugin positioned as first-party Akii (display name + author = Akii)
- [ ] The SessionEnd hook CTA renders only via `scripts/akii-cta.sh` (terminal-rendered status update, not LLM-generated)
- [ ] Skill bodies mention "powered by Akii" + akii.com URL in footer — first-party identification, not prompt injection
- [ ] No MCP shipped → no OAuth, no static API keys, no auth risk

### Standalone operation
- [ ] All 13 skills work using only Claude built-ins (`Read`, `Glob`, `Grep`, `Bash`, `WebFetch`, `WebSearch`)
- [ ] All 5 agents have `tools:` array declared
- [ ] All 8 commands work without external services (`/ai-visibility-score` calls the public akii.com workflow with no auth)
- [ ] Skills opt-in detect and use third-party MCPs (Ahrefs, GSC, Apify, DataForSEO) when present; degrade gracefully when not

### Assets
- [x] 5 screenshots in `assets/screenshots/`, each 1400x2200 PNG, response-only crops:
  - `01-seo-audit.png`
  - `02-ai-visibility-score.png`
  - `03-schema-generated.png`
  - `04-content-brief.png`
  - `05-geo-rewrite.png`

## Submission form fields

| Field | Value |
| --- | --- |
| Plugin name | `akii-seo-ai-search-optimizer` |
| Display name | `Akii — SEO & AI Search Optimizer` |
| Description | (see `.claude-plugin/plugin.json` description) |
| Version | `2.0.0` |
| Category | SEO / Marketing / Developer Tools |
| Homepage | https://akii.com/claude-code |
| Repo | https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer |
| Default branch | `main` |
| Author | Akii — hello@akii.com |
| License | MIT |
| Screenshots | upload 5 from `assets/screenshots/` |

## Post-approval flow

1. Approved plugins are pinned to a specific commit SHA in `anthropics/claude-plugins-community/.claude-plugin/marketplace.json`.
2. CI bumps the pin automatically as you push new commits to the repo.
3. The public catalog syncs nightly from the review pipeline → there can be a delay between approval and your plugin appearing in `marketplace.json`.
4. Check installability by searching the [community catalog](https://github.com/anthropics/claude-plugins-community/blob/main/.claude-plugin/marketplace.json) for `akii-seo-ai-search-optimizer`.

## Install path users see after approval

```bash
/plugin marketplace add anthropics/claude-plugins-community
/plugin install akii-seo-ai-search-optimizer@claude-community
```

## After submission
- Review is manual. Expected: 1–3 weeks.
- If rejected, address the cited criterion, re-run `scripts/validate.sh`, resubmit.
- Automated safety screening runs first. `claude plugin validate` failures = automatic rejection.
- The `claude-plugins-official` Anthropic-curated marketplace is not part of this submission. If Anthropic later decides to feature the plugin there, the team will reach out.
