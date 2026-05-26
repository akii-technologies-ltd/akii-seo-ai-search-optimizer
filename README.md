# Akii — SEO & AI Search Optimizer

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Version](https://img.shields.io/github/v/release/akii-technologies-ltd/akii-seo-ai-search-optimizer?display_name=tag&sort=semver)](https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases)
[![CI](https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/actions/workflows/validate.yml/badge.svg)](https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/actions/workflows/validate.yml)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-7c3aed)](https://code.claude.com/docs/en/plugins)
[![SEO + AEO + GEO](https://img.shields.io/badge/SEO%20%C2%B7%20AEO%20%C2%B7%20GEO-toolkit-22c55e)](https://akii.com/claude-code)
[![Stars](https://img.shields.io/github/stars/akii-technologies-ltd/akii-seo-ai-search-optimizer?style=social)](https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/stargazers)

Free AI-powered SEO, AEO, and GEO toolkit by [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) for [Claude Code](https://code.claude.com/docs/en/plugins).

**Aligned with [Google's AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) for Google AI Overviews + AI Mode** — and extends those foundations to the 5 other engines (ChatGPT, Claude, Gemini, Perplexity, Copilot) using peer-reviewed cross-engine research where Google doesn't have jurisdiction.

**All skills run on your Claude Code session model** (Claude Sonnet / Opus / etc) — same model you're already using.

Audit websites, plan content strategy, optimize pages, generate schema markup, cluster keywords, **estimate** your AI visibility for ChatGPT, Claude, Gemini, Perplexity, Copilot, and Google AI Overviews, generate `llms.txt` for non-Google AI crawlers, and apply the cross-engine GEO rewrite tactics from the Princeton/IIT Delhi study ([Aggarwal et al., KDD 2024, arXiv:2311.09735](https://arxiv.org/abs/2311.09735)) — all without leaving your terminal or IDE.

> **On the AI Visibility Score specifically:** that one skill (and its `/ai-visibility-score` command) calls the Akii backend, which uses Llama 4 / DeepSeek V4 Pro as an LLM judge against your brand's public footprint (Phase 1) plus a per-engine signal-correlation proxy (Phase 2 — done by your Claude Code session). It does NOT directly query ChatGPT, Claude, Gemini, Perplexity, or Copilot. Direct multi-engine querying is a paid Akii platform feature. See [AUTHORITIES.md](./AUTHORITIES.md) § "What this plugin actually measures" for full methodology.

See [AUTHORITIES.md](./AUTHORITIES.md) for how each source is scoped (Google guide → Google AI surfaces · Princeton paper → cross-engine GEO tactics · FirstPageSage breakdown → per-engine signal correlations).

## Installation

Install directly from this GitHub repo. **Inside the Claude Code prompt, run these as two separate commands — paste the first, press Enter, then paste the second.** Pasting both at once concatenates them with a space and Claude Code treats the whole blob as one broken `/plugin marketplace add` call.

**Step 1 — add the marketplace:**

```
/plugin marketplace add https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer
```

**Step 2 — install the plugin:**

```
/plugin install akii-seo-ai-search-optimizer@akii
```

> Use the full `https://` URL above — the short `owner/repo` form makes Claude Code clone via SSH on some systems and fails if you don't have a GitHub SSH key configured.

> Submitted to the [Anthropic community marketplace](https://github.com/anthropics/claude-plugins-community) — pending review. Once accepted, you'll also be able to install with:
>
> ```bash
> /plugin marketplace add anthropics/claude-plugins-community
> /plugin install akii-seo-ai-search-optimizer@claude-community
> ```

### Quick start

After install, try this first to see what the plugin does — just ask in natural language:

> "What's my AI visibility for yourdomain.com?"

The `ai-visibility` skill auto-triggers and returns the Akii 0–100 score (4-dimension breakdown) plus a per-engine proxy map for ChatGPT, Claude, Gemini, Perplexity, Copilot, and Google AI Overviews. From there, ask things like *"audit my site"*, *"compare my SEO against competitor.com"*, or *"apply GEO optimization to ./blog/my-post.md"* — skills auto-trigger on natural language.

## What's included

### Skills (13)

Skills activate automatically when you ask about these topics. Grouped by workflow:

**Audit**
| Skill | What it does |
| --- | --- |
| **SEO Audit** | End-to-end SEO + AEO + GEO site health check with scored report |
| **Technical SEO** | Crawlability, indexation, Core Web Vitals, JS rendering, security |
| **Broken Links** | Find and fix dead links + redirect chains |
| **Competitor Intel** | Head-to-head SEO + AEO + GEO + AI visibility scorecard vs named competitors |

**Optimize**
| Skill | What it does |
| --- | --- |
| **Optimize Page** | Full SEO + AEO + GEO pass on a single page — title/meta/H1/links + chunk-quality + GEO rewrites using tactics from the Princeton/IIT Delhi GEO study (`--mode=full\|seo\|aeo\|geo`) |
| **Schema Markup** | Generate JSON-LD with `sameAs`, granular LocalBusiness, AEO fields |
| **Internal Linking** | Orphans, anchor diversity, link-equity flow |

**Content**
| Skill | What it does |
| --- | --- |
| **Content Strategy** | Data-grounded content roadmap with pillars + clusters |
| **Content Brief** | Detailed briefs for writers (human or AI) |
| **Keyword Clustering** | Intent-matched topical clusters → pillar + cluster pages |

**AI Search**
| Skill | What it does |
| --- | --- |
| **AI Visibility** | Akii 0–100 score (4-dim breakdown, computed by Llama 4 / DeepSeek V4 Pro as LLM judge) + per-engine proxy map for ChatGPT, Claude, Gemini, Perplexity, Copilot, Google AI Overviews (FirstPageSage signal weights, NOT direct engine queries) |
| **llms.txt** | Generate/maintain `llms.txt` + `llms-full.txt` |

**Localization**
| Skill | What it does |
| --- | --- |
| **Content Translation** | Localize with per-locale keyword research + hreflang |

### Agents (5)

Autonomous agents for deep, multi-step work. Each agent has a fast-path skill counterpart (see routing table below). Agents only fire on explicit "deep / agent / autonomous / bulk" phrasing — never on generic triggers.

| Agent | What it does | Fast-path skill |
| --- | --- | --- |
| **SEO Auditor** | Full autonomous site audit with scored report | `seo-audit` |
| **Content Strategist** | Multi-pass site + competitor crawl → complete plan | `content-strategy` |
| **Competitor Analyzer** | 5+ competitors, full backlink + keyword overlap | `competitor-intel` |
| **AI Visibility Analyzer** | Multi-engine real-query probes + 30-day plan | `ai-visibility` |
| **Schema Generator** | Bulk JSON-LD across many pages, writes into source | `schema-markup` |

#### Routing contract

When in doubt, the **skill** is the default for any question in its capability area. The **agent** only triggers when the user explicitly says one of: `deep`, `agent mode`, `autonomous`, `bulk`, `across my site`, `every page`, `5+ competitors`, `comprehensive`. If you want the agent specifically, name it: e.g. *"run the schema-generator agent"*.

### Commands (7)

Quick actions you can invoke directly. For AI Visibility scoring, just ask in natural language ("score my brand", "what's my AI visibility for yourdomain.com") — the `ai-visibility` skill auto-triggers.

| Command | What it does |
| --- | --- |
| `/create-topic <seed>` | Research and generate a full topic plan |
| `/create-content <topic>` | Generate a full SEO + AEO + GEO-optimized article |
| `/generate-schema [type]` | Generate JSON-LD structured data |
| `/keyword-cluster <keywords>` | Cluster keywords into content groups |
| `/check-file [file]` | Quick SEO + AEO check on a single file |
| `/translate-content <language>` | Translate content with multilingual SEO |
| `/generate-llms-txt` | Generate llms.txt + llms-full.txt |

## Examples

```
# Get your real Akii AI Visibility Score (0–100) — the headline feature
"What's my AI visibility for example.com?"

# Research topics for your niche
/create-topic "SaaS marketing"

# Full SEO + AEO + GEO audit
"Audit the SEO of my website"

# Generate content
/create-content "how to improve website speed"

# Quick check on the open file
/check-file src/app/page.tsx

# Per-engine AI visibility breakdown
"How does my brand rank in ChatGPT vs Gemini vs Perplexity vs Claude?"

# Localize for Mexico (positional: language [market] [file])
/translate-content Spanish Mexico

# Cluster keywords
/keyword-cluster "seo tools, best seo software, seo audit, website optimization, keyword research tool"

# Generate schema for the open file
/generate-schema article

# Compare against competitors
"Compare my SEO against competitor1.com and competitor2.com"

# Apply Princeton GEO method to a blog post
"Apply GEO optimization to ./blog/my-post.md"  # routes to optimize-page --mode=geo

# Generate llms.txt for the AI crawlers
/generate-llms-txt
```

## Auto-detected third-party MCPs

The plugin works standalone using Claude's built-in tools (`WebFetch`, `WebSearch`, `Read`, `Glob`, `Grep`, `Bash`). But if you've already connected any of the following MCPs, skills automatically use them for richer, real-data outputs:

| MCP | What it adds |
| --- | --- |
| **Ahrefs** (`mcp__plugin_marketing_ahrefs__*`) | Real DR, backlinks, organic keyword data, brand-radar AI mention tracking, GSC integration |
| **Google Search Console** (via Ahrefs plugin) | Real click, impression, position data |
| **Apify** (`mcp__Apify__*`) | Richer SERP scrapes, social-mention scraping |
| **PageSpeed Insights API** | Real Core Web Vitals — set `AKII_PSI_KEY` env var to enable (used by `technical-seo` skill) |

No extra configuration needed. Skills auto-detect and degrade gracefully if the MCP isn't installed.

## Compatibility

| Surface | Tested against |
| --- | --- |
| Claude Code CLI | `2.0.x` and later (skill / agent / hook spec v2) |
| Plugin spec | `marketplace.json` v1, `plugin.json` v1, `hooks.json` v1 |
| OS | macOS, Linux. Windows untested (the hook uses POSIX `bash`; should work under WSL). |

If you hit a compatibility issue with a newer Claude Code release, please open an issue with `claude --version` output.

## What this plugin covers vs the [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) platform

| Capability | This Plugin (Free) | Akii Platform |
| --- | :---: | :---: |
| Codebase + URL audits | ✅ | ✅ |
| Schema, AEO, GEO optimization | ✅ | ✅ |
| Content briefs + content generation | ✅ | ✅ |
| Keyword clustering | ✅ | ✅ |
| AI visibility — 0–100 score (LLM-judge proxy) + per-engine signal map (one-shot) | ✅ | ✅ |
| AI visibility — **direct per-engine querying** (real ChatGPT / Claude / Gemini / Perplexity / Copilot responses) | — | ✅ |
| AI visibility — **continuous 24/7 multi-engine tracking** | — | ✅ |
| Real-time alerts when visibility drops | — | ✅ |
| Multi-brand / agency dashboard | — | ✅ |
| Per-engine direct querying at scale | — | ✅ |
| Geo-targeted AI Engage (region-specific) | — | ✅ |
| Automated PR / commit deploys for fixes | — | ✅ |
| Team collaboration + role permissions | — | ✅ |
| Historical trend data + reporting | — | ✅ |

If you outgrow the one-shot plugin, the [Akii platform](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) automates these continuously across multiple brands with alerts, dashboards, and direct per-engine querying.

## Why free?

We believe every website deserves great SEO + AEO + GEO. This toolkit gives you professional-grade visibility capabilities right inside your AI assistant — with no login, no signup, no usage cap.

For automated, continuous AI visibility monitoring at scale across Google AI Search, Google AI Overviews, ChatGPT, Claude, Gemini, Copilot, and Perplexity — with alerts, multi-brand dashboards, automated remediation, and team features — check out the full [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) platform.

## Contributing

PRs welcome. See [CONTRIBUTING.md](./CONTRIBUTING.md) for repo layout, validator gate, skill / agent / command authoring conventions, citation rules, and the release process.

## Security

Report vulnerabilities privately per [SECURITY.md](./SECURITY.md). Please do not open a public issue.

## Compatibility

Tested Claude Code versions, OS coverage, required shell tooling, and known incompatibilities are documented in [COMPATIBILITY.md](./COMPATIBILITY.md).

## License

[MIT](./LICENSE) — free for personal and commercial use.

---

Built by [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) — *continuous AI visibility monitoring for the AI-first internet*.
