# Authoritative sources

This plugin's recommendations come from three primary sources, each scoped to where it has actual authority. We don't pretend any single source covers the whole AI search landscape — the engines have different ranking systems, owners, and signals.

## Source matrix

| Source | Authoritative for | Scope |
|---|---|---|
| [Google AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide) | **Google AI Overviews + AI Mode** | Google's own surfaces. First-party guidance from the engine owner. |
| [Aggarwal et al., "GEO: Generative Engine Optimization" (KDD 2024)](https://arxiv.org/abs/2311.09735) | **Cross-engine GEO tactics** | Peer-reviewed (ACM SIGKDD 2024). Tested on a multi-LLM benchmark. Five validated tactics: citation integration, quotation addition, statistics addition, fluency optimization, authoritative tone. |
| [FirstPageSage GEO Algorithm Breakdown](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/) (2024, updated 2026) | **Per-engine signal correlations** (ChatGPT, Gemini, Perplexity, Claude, Copilot) | Proprietary vendor survey over 11k commercial queries. Not peer-reviewed. Observed correlations, not model internals. |

## How they interact

Each engine sits in a different authority window:

| Engine | Primary authority | Why |
|---|---|---|
| **Google AI Overviews** | Google AI Optimization Guide | Google owns the engine and publishes official guidance. Princeton tactics aren't tested against Google's specific ranking systems. |
| **Google AI Mode** | Google AI Optimization Guide | Same as above. |
| **ChatGPT** (Bing-rooted) | Princeton paper + FirstPageSage | Google has no jurisdiction over how OpenAI ranks brands. |
| **Anthropic Claude** | Princeton paper + FirstPageSage | Same. |
| **Perplexity** | Princeton paper + FirstPageSage | Same. |
| **Microsoft Copilot** (Bing-rooted) | Princeton paper + FirstPageSage | Same. |
| **Standalone Gemini** (not via Google Search) | Princeton paper + FirstPageSage | Where Gemini doesn't pull from Google index, Google's guide doesn't apply. |

## Where the sources agree

- **Helpful, people-first content** wins. All three sources.
- **Crawlable, well-structured pages** are foundational. All three.
- **Anti-spam, anti-fake-mentions, anti-keyword-stuffing.** Google guide explicitly rejects scaled content abuse; Princeton measured keyword stuffing as -8.7% mean AI visibility; FirstPageSage data weights authentic signals.
- **Schema is useful but not required.** Google guide says schema isn't required for AI search but is good for rich results. Princeton paper doesn't require it. We treat it the same.

## Where the sources disagree (and how we handle it)

| Topic | Google guide says | Princeton / FirstPageSage say | Our plugin's stance |
|---|---|---|---|
| `llms.txt` | Not needed *for Google* | — | Generate it for non-Google AI crawlers (Anthropic, Perplexity, Cohere, others). Skill body says this explicitly. |
| Chunking content | Not needed *for Google* | AEO best practice for engines that chunk during retrieval | Optional. Helps ChatGPT/Claude/Perplexity extract clean answers; neutral-to-positive for Google. |
| Rewriting content for AI | Not needed *for Google* | +40% lift in paper benchmark (cross-LLM) | Apply Princeton tactics for non-Google engines via `optimize-page --mode=geo`. For Google AI surfaces specifically, follow Google's guide. |
| Per-engine signal optimization | "For Google's perspective, it's all SEO" | Each engine has different weights | Both true. Foundational SEO covers Google; per-engine fixes address the other 5. |

## Anti-patterns all three sources reject

- Bulk AI-generated thin content
- Buying reviews or "mentions"
- Keyword stuffing (Princeton measured the harm; Google guide rejects via spam policy; FirstPageSage data deweights it)
- Astroturfing list inclusions
- Manipulating ranking via scaled content abuse

The plugin enforces these in skill rules.

## What this plugin actually measures

Critical methodology note — read this before drawing conclusions from the AI Visibility Score.

### How the plugin runs at all

**The plugin is markdown.** Every skill, agent, and command is markdown that gets executed by your Claude Code session model (Claude Sonnet / Opus / Haiku — whichever you have selected). There is no separate inference happening for 12 of 13 skills, all 5 agents, and all 3 commands. They run on your Claude.

The exception is the AI Visibility Score (the `ai-visibility` skill's Phase 1) — which calls the akii.com backend. That backend uses a different model (Llama 4 / DeepSeek V4 Pro) as a judge. Details below.

### Phase 1 — Akii API score (the 0–100 number)
- **Mechanism:** an open-source LLM (currently Llama 4 Maverick or DeepSeek V4 Pro, whichever is enabled for the free homepage tier) acts as a judge. It is shown your brand's public footprint and asked to score it across four dimensions: Brand Recognition, Brand Understanding, Content Coverage, Brand Sentiment.
- **What this IS:** a directionally useful estimate of how a generative engine would likely describe your brand, computed by a single open-source model.
- **What this is NOT:** a direct query of ChatGPT, Claude, Gemini, Perplexity, or Copilot. The plugin does not call those engines' APIs at any point.
- **Why open-source:** lets Akii offer the free tier without paying OpenAI / Anthropic / Google per-query fees.

### Phase 2 — Per-engine vulnerability map
- **Mechanism:** the plugin gathers public web signals (SERP appearances, business-DB listings, review ratings, social sentiment) and maps them to each engine's known signal weighting per [FirstPageSage's GEO study](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/).
- **What this IS:** a per-engine score derived from observed correlations between public signals and engine output.
- **What this is NOT:** a direct query of any of the named engines. The Ahrefs Brand Radar MCP, if connected, replaces the proxy with direct measurement for ChatGPT / Claude / Gemini / Perplexity.

### What direct multi-engine querying requires
- **Paid Akii platform** — continuous monitoring tier queries the named engines directly on a schedule and reports actual responses, share-of-voice over time, and alerts.
- **Ahrefs Brand Radar MCP** — connect it and Phase 2 auto-detects and uses real Brand Radar data instead of the SERP-signal proxy.

The free plugin is honest about being a proxy. Both proxies are useful (Akii uses them in production), but the user deserves to know what's producing the numbers they see.

## What we don't claim

- We do **not** claim the Princeton paper validated the Akii plugin. The paper validated the *tactics*; the plugin implements them.
- We do **not** claim Google endorses or has reviewed the plugin. We align with Google's guidance because it's the authoritative source for Google's own surfaces.
- We do **not** treat FirstPageSage's per-engine percentages as model internals. They're observed correlations from a vendor's survey. We attribute inline whenever we surface the numbers.
- We do **not** claim the free plugin directly queries ChatGPT, Claude, Gemini, Perplexity, or Copilot. See "What this plugin actually measures" above.

## How to verify

Every claim in the plugin should link back to one of these three sources or to the underlying primary source (research paper, vendor doc, engine owner doc). If you find a claim that doesn't, open an issue and we'll fix it.
