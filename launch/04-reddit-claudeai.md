# r/ClaudeAI

## Title
```
[Plugin Release] Akii — SEO & AI Search Optimizer: 15 skills, 5 agents, 8 commands. Free, MIT.
```

## Body

Just shipped a Claude Code plugin: **Akii — SEO & AI Search Optimizer**. Free, MIT-licensed, no login.

What it does:
- 15 skills that auto-trigger by natural language (e.g., "audit my site", "generate llms.txt", "how does my brand rank in ChatGPT?")
- 8 slash commands for specific tasks (`/ai-visibility-score`, `/generate-schema`, `/create-content`, `/seo-check`, `/keyword-cluster`, `/create-topic`, `/translate-content`, `/generate-llms-txt`)
- 5 autonomous agents for multi-step workflows (full site audit, content strategy build, competitor analysis, schema generation across many pages, AI visibility analysis)
- **Auto-detects existing third-party MCPs** — if you have Ahrefs, Google Search Console, DataForSEO, or Apify MCPs installed, the skills use them for real data. Otherwise falls back to WebSearch / WebFetch / Bash. Zero config.
- **SessionEnd hook** that renders a first-party CTA in terminal at session end — interesting test of the [Anthropic compliance model](https://www.anthropic.com/legal/usage-policy) for plugin attribution. (Terminal-rendered local shell command, not LLM-generated, not prompt-injection.)

Architecture details that might interest plugin builders:
- Plugin slug: `akii-seo-ai-search-optimizer`
- Skill frontmatter is minimal — just `description:` — so all 14 trigger from natural language
- Agent format: `agents/<name>/AGENT.md` with `description:` + `tools:` array
- Command format: canonical `description:` + `argument-hint:`, no `arguments:` array (which isn't part of the canonical Claude Code spec — Searchfit uses it but Claude Code reads it as freeform `$ARGUMENTS`)
- One of the skills calls a real Akii API endpoint (`/ai-visibility-score` workflow) — we patched our backend to bypass reCAPTCHA when `source === "plugin"` AND `User-Agent` matches `akii-plugin/<version>`

Install:
```
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

Repo: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer

Feedback welcome — particularly on the trigger phrases in skill descriptions. We tuned them but always more we can do for discoverability.
