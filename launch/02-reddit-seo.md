# r/SEO

## Title
```
We open-sourced a free SEO + AEO + GEO toolkit that works inside Claude Code. No login, no limits. AMA.
```

## Body

Hey r/SEO. We just released a free MIT-licensed Claude Code plugin called **Akii — SEO & AI Search Optimizer**.

It addresses what most SEO tools still don't: each AI engine ranks brands by completely different signals. ChatGPT pulls from Bing list articles + reviews. Gemini relies on Google domain authority + Google Business Profile. Perplexity pulls top-5 Google + reviews for ordering. Claude leans 68% on Hoovers/Bloomberg/IBISWorld. Copilot mirrors ChatGPT.

The plugin encodes that into skills you trigger by asking Claude things like "audit my site" or "why doesn't ChatGPT recommend us?". 13 skills, 5 agents, 8 commands.

Highlights:

- **`/ai-visibility-score <domain>`** — runs the real Akii visibility workflow against any domain. Returns a 0–100 composite + 4-dim breakdown (recognition, understanding, content coverage, sentiment) + identified competitors. Same workflow that powers the akii.com homepage tool.
- **GEO Optimization skill** — applies the empirically validated tactics from the Princeton / IIT Delhi / Allen Institute GEO study (up to +40% AI visibility lift, +115% for pages ranked outside top 5). And it explicitly avoids keyword stuffing, which the same study showed actually drops AI visibility ~10%.
- **Schema Markup skill** — generates JSON-LD with `sameAs`, granular LocalBusiness subtypes (FinancialService, MedicalBusiness etc), `currenciesAccepted`, `priceRange`, `actionableFeedbackPolicy`. The AEO-optimized fields most generators skip.
- **Auto-detects your Ahrefs MCP** — if you already pay for Ahrefs (or GSC, DataForSEO, Apify), skills use them for real data automatically.
- **`/generate-llms-txt`** — emerging standard. Builds llms.txt + llms-full.txt for AI crawlers.

Free forever. No login. No cap. We monetize via the paid Akii platform which adds 24/7 monitoring + alerts + multi-brand dashboards.

Install (requires Claude Code):
```
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

Repo: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer

AMA — happy to talk per-engine algorithm weights, Princeton GEO tactics, why we chose Claude Code over building a SaaS, or whatever.

---

## Rules to follow on r/SEO
- Lead with the value, not the company
- Engage every commenter for 24h
- Don't post in any other subreddit within 90 min of this one
- If mods remove for self-promo, accept it gracefully + reach out via modmail
