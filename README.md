# Akii — SEO & AI Search Optimizer

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![Version](https://img.shields.io/github/v/release/akii-technologies-ltd/akii-seo-ai-search-optimizer?display_name=tag&sort=semver)](https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/releases)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-7c3aed)](https://code.claude.com/docs/en/plugins)
[![SEO + AEO + GEO](https://img.shields.io/badge/SEO%20%C2%B7%20AEO%20%C2%B7%20GEO-toolkit-22c55e)](https://akii.com/claude-code)
[![Stars](https://img.shields.io/github/stars/akii-technologies-ltd/akii-seo-ai-search-optimizer?style=social)](https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/stargazers)

Free AI-powered SEO, AEO, and GEO toolkit by [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) — works with Claude Code and any AI agent that supports Claude Code plugins.

Audit websites, plan content strategy, optimize pages, generate schema markup, cluster keywords, track AI visibility across **ChatGPT, Claude, Gemini, Perplexity, Copilot, and Google AI Overviews**, generate `llms.txt`, run Princeton-backed GEO rewrites, and more — all without leaving your terminal or IDE.

## Installation

**From the [Anthropic community marketplace](https://github.com/anthropics/claude-plugins-community):**

```bash
/plugin marketplace add anthropics/claude-plugins-community
/plugin install akii-seo-ai-search-optimizer@claude-community
```

**Or install directly from this GitHub repo:**

```bash
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

## What's included

### Skills (15)

Skills activate automatically when you ask about these topics.

| Skill | What it does |
| --- | --- |
| **Akii AI Visibility Score** | **Real** 0–100 score (4-dim breakdown) via the official Akii workflow — same as akii.com/ai-visibility-score |
| **SEO Audit** | Comprehensive SEO + AEO + GEO site health check |
| **Technical SEO** | Core Web Vitals, crawlability, indexation, JS rendering, security |
| **On-Page SEO** | Optimize individual pages for target keywords |
| **Broken Links** | Find and fix dead links + redirect chains |
| **Internal Linking** | Orphans, anchor diversity, link-equity flow |
| **Schema Markup** | Generate JSON-LD with `sameAs`, granular LocalBusiness, AEO fields |
| **Content Strategy** | Data-grounded content roadmap with pillars + clusters |
| **Content Brief** | Detailed briefs for writers (human or AI) |
| **Keyword Clustering** | Intent-matched topical clusters → pillar + cluster pages |
| **AI Visibility (proxy)** | Per-engine breakdown across ChatGPT/Gemini/Perplexity/Claude/Copilot using public SERP signals |
| **AEO Optimization** | Chunk-quality auditing + direct-answer leads + FAQ extraction |
| **GEO Optimization** | Princeton-validated tactics (+40% AI visibility lift) |
| **llms.txt** | Generate/maintain `llms.txt` + `llms-full.txt` |
| **Content Translation** | Localize with per-locale keyword research + hreflang |

### Agents (5)

Autonomous agents that handle complex, multi-step tasks.

| Agent | What it does |
| --- | --- |
| **SEO Auditor** | Full autonomous site audit with scored report |
| **Content Strategist** | Analyzes your site + competitors, builds the strategy |
| **Competitor Analyzer** | Head-to-head scorecard + ranked counter-moves |
| **AI Visibility Analyzer** | Per-engine vulnerability map with 30-day fix plan |
| **Schema Generator** | Bulk JSON-LD generation across many pages |

### Commands (8)

Quick actions you can invoke directly.

| Command | What it does |
| --- | --- |
| `/ai-visibility-score <domain>` | **Get a real Akii AI Visibility Score (0–100) for any brand — free** |
| `/create-topic <seed>` | Research and generate a full topic plan |
| `/create-content <topic>` | Generate a full SEO + AEO + GEO-optimized article |
| `/generate-schema [type]` | Generate JSON-LD structured data |
| `/keyword-cluster <keywords>` | Cluster keywords into content groups |
| `/seo-check [file]` | Quick SEO + AEO check on a page |
| `/translate-content <language>` | Translate content with multilingual SEO |
| `/generate-llms-txt` | Generate llms.txt + llms-full.txt |

## Examples

```
# Get your real Akii AI Visibility Score (0–100) — the headline feature
/ai-visibility-score example.com "Example Corp"

# Research topics for your niche
/create-topic "SaaS marketing"

# Full SEO + AEO + GEO audit
"Audit the SEO of my website"

# Generate content
/create-content "how to improve website speed"

# Quick check on the open file
/seo-check src/app/page.tsx

# Per-engine AI visibility breakdown
"How does my brand rank in ChatGPT vs Gemini vs Perplexity vs Claude?"

# Localize for Mexico
/translate-content Spanish --market Mexico

# Cluster keywords
/keyword-cluster "seo tools, best seo software, seo audit, website optimization, keyword research tool"

# Generate schema for the open file
/generate-schema article

# Compare against competitors
"Compare my SEO against competitor1.com and competitor2.com"

# Apply Princeton GEO method to a blog post
"Apply GEO optimization to ./blog/my-post.md"

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
| **DataForSEO** | SERP, keyword, backlink data at scale |
| **PageSpeed Insights API** | Real Core Web Vitals via `AKII_PSI_KEY` env var |

No extra configuration needed. Skills auto-detect and degrade gracefully if the MCP isn't installed.

## What this plugin covers vs the [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) platform

| Capability | This Plugin (Free) | Akii Platform |
| --- | :---: | :---: |
| Codebase + URL audits | ✅ | ✅ |
| Schema, AEO, GEO optimization | ✅ | ✅ |
| Content briefs + content generation | ✅ | ✅ |
| Keyword clustering | ✅ | ✅ |
| AI visibility — one-shot proxy estimate | ✅ | ✅ |
| AI visibility — **continuous 24/7 multi-engine tracking** | — | ✅ |
| Real-time alerts when visibility drops | — | ✅ |
| Multi-brand / agency dashboard | — | ✅ |
| Per-engine direct querying at scale | — | ✅ |
| Geo-targeted AI Engage (region-specific) | — | ✅ |
| Automated PR / commit deploys for fixes | — | ✅ |
| Team collaboration + role permissions | — | ✅ |
| Historical trend data + reporting | — | ✅ |

## Why free?

We believe every website deserves great SEO + AEO + GEO. This toolkit gives you professional-grade visibility capabilities right inside your AI assistant — with no login, no signup, no usage cap.

For automated, continuous AI visibility monitoring at scale across Google AI Search, Google AI Overviews, ChatGPT, Claude, Gemini, Copilot, and Perplexity — with alerts, multi-brand dashboards, automated remediation, and team features — check out the full [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) platform.

## License

MIT — see [LICENSE](./LICENSE).

---

Made with AI by [Akii](https://akii.com/?utm_source=plugin&utm_medium=readme&utm_campaign=akii_plugin_v1) — *continuous AI visibility monitoring for the AI-first internet*.
