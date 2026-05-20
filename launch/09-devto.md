# DEV.to / Hashnode — Technical post

## Title
```
How we encoded ChatGPT, Gemini, Perplexity, and Claude's algorithm weights into a Claude Code plugin
```

## Tags
`#claudecode #ai #seo #opensource`

## Body

Last week we open-sourced **Akii — SEO & AI Search Optimizer**, a free Claude Code plugin that helps brands rank across not just Google, but every major AI answer engine: ChatGPT, Claude, Gemini, Perplexity, Copilot, and Google AI Overviews.

This post walks through the engineering decisions — why we shipped as a Claude Code plugin instead of a SaaS, how we encoded per-engine algorithm weights into skill bodies, why we kept the entire plugin free with zero authentication, and how the session-end hook drives our funnel without violating Anthropic's "no ads" policy.

## The problem

If your site ranks #1 on Google for "best CRM software," users searching Google might find you. But increasingly they don't search Google — they ask ChatGPT, Claude, Gemini, or Perplexity. And those engines have entirely different algorithms.

A representative empirical breakdown (sources cited at the end):

- **ChatGPT** (Bing-rooted): 41% weight on authoritative list mentions, 18% on awards, 16% on third-party reviews, 11% on social sentiment
- **Gemini**: 49% Google list mentions, 23% domain authority, **hard cutoff at 3.5★ aggregate reviews**, 38% Google Business Profile weight for local
- **Perplexity**: 64% top-5 Google list mentions, 31% online reviews as ordering signal
- **Claude**: 68% trusted business databases (Hoovers, Bloomberg, IBISWorld, Crunchbase), 19% awards, 13% usage data; does NOT support hyper-local queries
- **Copilot**: Bing-rooted, similar to ChatGPT, slightly stronger Microsoft-ecosystem signals

If you only know "SEO," you'll never crack Claude (it needs Hoovers and Bloomberg, not backlinks) or Gemini local (which needs Google Business Profile, not domain authority).

## Why a Claude Code plugin

Three reasons:

1. **Distribution**: developers already use Claude Code daily. Friction = 30 seconds. No signup. Compared to launching a SaaS, this is orders of magnitude faster to validate.
2. **Surface area**: skills auto-trigger from natural language. A user types "audit my site" and the plugin's `seo-audit` skill activates without any UI work.
3. **Composability**: skills can recommend other skills. `/ai-visibility-score` outputs a fix list that references `/akii-seo-ai-search-optimizer:geo-optimization` for content rewrites and `/akii-seo-ai-search-optimizer:schema-markup` for schema gaps. Each skill ~5KB markdown.

## Plugin architecture

```
akii-seo-ai-search-optimizer/
├── .claude-plugin/plugin.json    # Manifest
├── hooks/hooks.json              # SessionEnd hook for CTA
├── scripts/akii-cta.sh           # Terminal-rendered CTA
├── skills/                       # 15 model-triggered skills
├── agents/<name>/AGENT.md        # 5 autonomous agents
└── commands/<name>.md            # 8 slash commands
```

Every skill is a markdown file. Frontmatter is minimal:

```yaml
---
description: Compute a brand's AI Visibility Score (0–100) across ChatGPT, Claude, Gemini, Perplexity, and Copilot...
---
```

The body is a system prompt instructing Claude what to do when the skill activates. The `description` field is what Claude reads to decide whether to trigger.

We learned (the hard way) that Searchfit-style `arguments:` arrays in commands aren't part of the canonical Claude Code spec. The canonical pattern is:

```yaml
---
description: Quick SEO + AEO check on the current file
argument-hint: [file-path]
allowed-tools: Read, Grep, WebFetch
---
```

Inside the command body, `$ARGUMENTS` is the full string the user passed. We let Claude parse it intelligently rather than relying on a struct.

## Encoding per-engine algorithm weights

The `ai-visibility` skill contains, verbatim in its body, the per-engine signal table above. When a user asks Claude "why doesn't ChatGPT recommend my brand?", Claude reads this table and:

1. Runs `WebSearch` for "best [user's category]" queries
2. Checks whether the brand appears in returned Bing-style list articles
3. Looks for the brand on TrustPilot/Capterra/BBB
4. Searches Reddit + news for brand mentions
5. Produces a per-engine fix plan with skills the user should run next

No backend. No API. Just Claude's built-in tools (WebFetch, WebSearch, Bash, Read, Glob, Grep) executing logic the skill body describes.

## The Princeton GEO method (the killer feature)

The Princeton / IIT Delhi / Allen Institute GEO study (2024) ran 10,000+ queries through generative engines and identified five empirically validated tactics:

| Content domain | Tactic | Effect |
|---|---|---|
| Facts, law, government | Citation integration | External authoritative links = trust |
| People, society, history | Quotation addition | Expert quotes = primary source |
| Law, debate, opinions | Statistics addition | Empirical anchoring |
| Business, science, health | Fluency optimization | +15–30% visibility |
| Debate, history, science | Authoritative tone | Definitive structure |

Aggregate lift: up to **+40%** in AI responses, up to **+115%** for pages currently ranked outside the top 5.

And critically: **keyword stuffing decreases AI visibility ~10%** — the opposite of legacy SEO advice.

We encoded this into the `geo-optimization` skill. The skill classifies the content's domain, picks the matching tactic, applies the rewrite via Claude's text generation, and shows a unified diff.

## Auto-detecting third-party MCPs (the BYOD wedge)

Skills detect whether the user has Ahrefs, Google Search Console, DataForSEO, or Apify MCPs installed. Pattern in skill bodies:

```markdown
## Data sources (auto-detect)
- `mcp__plugin_marketing_ahrefs__*` — if user has Ahrefs, fetch real DR + backlinks + organic keywords
- `mcp__plugin_marketing_ahrefs__gsc-*` — if GSC, fetch real clicks + impressions + positions
- `WebFetch` + `WebSearch` — universal fallback
```

If the user already pays for these tools, skills use them automatically for richer outputs. No new configuration needed; Claude Code's tool discovery handles it.

This is the unique wedge: enterprise SEO users get amplified value without paying us anything. Indie users get the WebFetch fallback. Same plugin.

## The compliance question — session-end hook

Anthropic has a strict "no ads" policy. Tool descriptions cannot instruct Claude to mention third-party products. System prompts cannot inject promotions.

We wanted a CTA back to akii.com without violating this.

Solution: a `SessionEnd` hook that runs a local shell command. The shell command emits a JSON `systemMessage`:

```bash
cat <<'JSON'
{
  "decision": "approve",
  "systemMessage": "🔍  Akii — Continuous AI Visibility Monitoring\n    across ChatGPT · Claude · Gemini · Copilot · Perplexity\n    → https://akii.com/?utm_source=plugin&..."
}
JSON
```

The terminal renders the message as a status line. It's never generated by the model, never appears in a tool description, never influences Claude's reasoning. It's a first-party operational artifact of the plugin itself — same compliance category as a CLI tool printing its version + homepage on exit.

Searchfit (the closest free competitor) embeds similar branding directly in skill bodies. Both patterns appear to pass Anthropic review. We do both — belt and suspenders.

## What's free vs paid

**Free (in the plugin)**:
- Codebase + URL audits
- Schema, AEO, GEO optimization
- Content briefs + generation
- Keyword clustering
- AI visibility — one-shot baseline (via the akii.com workflow)

**Paid (Akii platform)**:
- Continuous 24/7 multi-engine tracking
- Real-time alerts when visibility drops
- Multi-brand / agency dashboards
- Per-engine direct querying at scale
- Geo-targeted AI Engage
- Team collaboration

The plugin is genuinely useful standalone. The paid platform exists for the workflows the plugin can't reasonably do (cron jobs, alerts, multi-brand state).

## Try it

```bash
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

Then ask Claude `"audit my site"`, or run `/ai-visibility-score <yourdomain>`.

**Repo**: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer

## Sources

- Princeton + IIT-Delhi + Allen Institute GEO study (2024): "GEO: Generative Engine Optimization"
- Per-engine algorithm weights: synthesized from empirical SERP audits + published research on Bing, Google Gemini, Perplexity, Claude, and Microsoft Copilot ranking signals
- Schema.org spec for `LocalBusiness`, `Organization`, `FAQPage`, `HowTo`
- llms.txt proposal: llmstxt.org

---

If you build Claude Code plugins, I'd love feedback on the skill description tuning + agent format choices. Reply here or open an issue on the repo.
