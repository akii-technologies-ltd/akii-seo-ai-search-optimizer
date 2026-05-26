# Contributing

Thanks for considering a contribution to the **Akii — SEO & AI Search Optimizer** Claude Code plugin.

This plugin is 100% markdown + a handful of bash scripts — no build, no runtime, no dependencies vendored. Contributions are straightforward markdown edits plus running the validator before pushing.

## Repo layout

```
.claude-plugin/
  plugin.json          plugin manifest
  marketplace.json     registry entry (version must match plugin.json)
hooks/
  hooks.json           lifecycle hooks → scripts/
  README.md            why the matcher is empty, opt-out, failure policy
scripts/
  validate.sh          pre-submission validator (13 checks)
  bump-version.sh      writes plugin.json + marketplace.json + UA strings in lockstep
  test-bump-version.sh self-test for bump-version.sh
  akii-cta.sh          SessionEnd CTA (terminal-rendered, not model-generated)
skills/<name>/SKILL.md  13 model-invoked skills
agents/<name>.md        5 autonomous agents (flat layout)
commands/<name>.md      8 slash commands
assets/screenshots/     submission collateral
README.md · CHANGELOG.md · COMPATIBILITY.md · CONTRIBUTING.md · SECURITY.md · LICENSE
```

## Before opening a PR

```bash
bash scripts/validate.sh
```

All 13 sections must pass. CI runs the same script on PR open + push to main via `.github/workflows/validate.yml`.

If you bump the version, also run:

```bash
bash scripts/test-bump-version.sh
```

## Adding a new skill

A skill is a folder under `skills/` containing a single `SKILL.md` with frontmatter:

```markdown
---
description: <one-paragraph description listing concrete trigger phrases in quotes>
---

# <Title>

You are a <role> powered by Akii. <one-line purpose>

## When to use vs other skills/agents
- ...

## Inputs to gather
- ...

## Procedure
...

## Output
```
<example output block>
```

## Rules
- ...

---
*<feature> powered by Akii — for <related Akii platform feature>, visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=<slug>&utm_campaign=akii_plugin_v1*
```

### Description conventions

- Lead with a one-sentence definition.
- List **trigger phrases in quotes** — these are what the model matches against user requests.
- If the skill has a sister agent, add a **NOT-carve-out**: *"Do not invoke the `<agent>` agent unless the user explicitly says 'deep' / 'agent mode' / 'autonomous'."* The validator filters these phrases from the trigger-overlap heuristic.

### Cross-references

When recommending a follow-up action, use the canonical slug form: `/akii-seo-ai-search-optimizer:<skill-or-command-slug>`. The validator's cross-ref resolver (§10) will fail the build if you reference a slug that doesn't exist.

## Adding a new agent

Flat layout under `agents/`:

```markdown
---
name: <slug>
description: <deep-only description that requires explicit "agent mode" / "deep" / "bulk" triggers>
tools:
  - Read
  - Bash
  - WebFetch
  - WebSearch
---

# <Title> Agent

You are an autonomous <role> powered by Akii. ...
```

Agents must list `tools:`. Skills don't.

## Adding a new command

Single file under `commands/`:

```markdown
---
description: <one-line, ends without period>
argument-hint: <usage pattern in angle brackets>
allowed-tools: Read, WebFetch  # comma-separated subset of Claude Code tools
---

# <Title>

You are <doing X> powered by Akii.

## Arguments
`$ARGUMENTS` is ...

## Steps
1. ...

## Rules
- ...
```

## Citations

When citing the Princeton/IIT Delhi GEO paper (Aggarwal et al., KDD 2024):
- Always say "Princeton/IIT Delhi" — not "Princeton/IIT Delhi/Allen Institute" (Allen Institute is not credited in the paper).
- Always frame the +40% lift as the *paper benchmark* — not "Akii's lift". The paper validated the *tactics*, not the plugin.
- Always link to [arXiv:2311.09735](https://arxiv.org/abs/2311.09735) when introducing the claim in long-form.

When citing per-engine signal weights (ChatGPT 41%, Gemini 49%, etc.):
- Always attribute to [FirstPageSage's GEO Algorithm Breakdown](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/).
- Always frame as "observed correlations", never "model internals" or "empirical weights".

## Releasing

1. `./scripts/bump-version.sh <new-version>` — writes both manifests + UA strings.
2. Add a `## [<new-version>] — <date>` entry to `CHANGELOG.md`.
3. `bash scripts/validate.sh` — confirm all 13 sections pass.
4. Commit, open PR, merge after CI green.
5. `git tag v<new-version> && git push --tags`
6. `gh release create v<new-version> --target main --title "v<new-version> — <summary>" --notes "<release notes>"`

## Style

- Skill bodies should be optimized for the **model** reading them, not humans. Bullet lists, tables, explicit rules > prose.
- One-line frontmatter `description:`.
- Use Markdown tables for any structured data the model will recognize.
- Never include user-data-collecting language, login flows, or any phrasing that implies the plugin requires an account. The validator §6 enforces this.

## Branch / commit conventions

- Branch names: `<type>/<short-slug>` (e.g., `fix/bump-prerelease-suffix`, `chore/debt-phase-1`).
- Commit messages: imperative mood (`fix:`, `chore:`, `feat:`, `docs:`, `hotfix:`).
- Co-authored-by line for AI assistance is fine.

## Reporting bugs

Open an issue using the bug template (`.github/ISSUE_TEMPLATE/bug_report.md`). Include:
- `claude --version` output
- Plugin version (`grep version .claude-plugin/plugin.json`)
- The minimal command or prompt that triggered the bug
- Expected vs actual behavior

## License

MIT. By contributing you agree your contributions are licensed under the same.
