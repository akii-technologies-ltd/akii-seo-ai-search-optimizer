# Indie Hackers — Milestone Post

## Title
```
Shipped: free Claude Code plugin for SEO + AEO + GEO (15 skills, 5 agents, 8 commands)
```

## Body

Just shipped **Akii — SEO & AI Search Optimizer**, a free open-source Claude Code plugin.

**Problem**: Indie founders ship landing pages, blog posts, docs. SEO is critical for organic acquisition. But "SEO" now means three things:

- **SEO** for Google rankings
- **AEO** (Answer Engine Optimization) for being cited by ChatGPT/Perplexity/Claude
- **GEO** (Generative Engine Optimization) for appearing in Google AI Overviews

Most SEO tools are $99–$999/mo and only cover SEO. Founders can't afford that AND aren't getting AEO/GEO coverage anyway.

**Solution**: A free, no-login, MIT-licensed Claude Code plugin that covers all three.

What's in it:
- 15 skills (auto-trigger from natural language)
- 5 autonomous agents (full audits, content strategy, competitor analysis)
- 8 slash commands (`/ai-visibility-score`, `/generate-schema`, `/create-content`, etc.)
- Auto-detects your existing Ahrefs / GSC / Apify MCPs for real data
- Princeton GEO method (+40% AI visibility lift) encoded in `/akii-seo-ai-search-optimizer:geo-optimization`
- Stop hook funnel back to akii.com for the continuous-monitoring paid tier

**How we monetize**: The free plugin handles one-off work. The paid Akii platform adds 24/7 monitoring + real-time alerts + multi-brand dashboards. The plugin's session-end hook + UTM-tagged CTAs drive plugin → akii.com → waitlist → paid signup.

**Build time**: ~3 days of focused work after we landed on the architecture. Pure markdown + bash; no backend new code for the plugin itself (the existing akii.com workflow handles the `/ai-visibility-score` command). Probably the lowest-effort high-leverage thing we've shipped.

**Install** (requires Claude Code):
```
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

**Repo**: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer
**Landing**: https://akii.com/claude-code

Curious — does anyone else here use Claude Code as a distribution channel? It feels underrated. The friction is genuinely 30 seconds + your audience is technical buyers.
