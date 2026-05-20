# r/SaaS

## Title
```
Your SaaS ranks #1 on Google but is invisible inside ChatGPT. We open-sourced a free plugin that fixes that.
```

## Body

Most SaaS founders we talk to are surprised by the same thing: their site is the top organic result on Google, but when buyers ask ChatGPT "best [category] tool" — their brand is never named. Or worse, a competitor is recommended in their place.

That's because ChatGPT doesn't read Google. It reads Bing + the top "best X" list articles + reviews from TrustPilot, Capterra, G2, BBB. Each AI engine has its own algorithm:

- **ChatGPT**: 41% authoritative list mentions, 16% reviews, 11% social sentiment
- **Gemini**: 49% Google list mentions, 23% domain authority, **hard cutoff at 3.5★ reviews**
- **Perplexity**: 64% top-5 Google list mentions, 31% reviews for ordering
- **Claude**: 68% trusted business DBs (Hoovers, Bloomberg, IBISWorld, Crunchbase), skews enterprise

We built a free Claude Code plugin that encodes this and gives you per-engine fix paths. **No login, no signup, no usage cap.**

Concrete things it does for SaaS founders:

1. **`/ai-visibility-score example.com`** — get a real 0–100 score for your brand with 4-dim breakdown. Same workflow that powers akii.com.
2. **`/akii-seo-ai-search-optimizer:ai-visibility`** — full per-engine vulnerability map with a 30-day fix plan.
3. **`/akii-seo-ai-search-optimizer:geo-optimization`** — apply Princeton-validated tactics to a blog post (up to +40% AI visibility lift in their controlled study).
4. **`/generate-schema organization`** — Organization JSON-LD with `sameAs` linking to your Crunchbase, Wikipedia, LinkedIn, X — the cross-corroboration AI engines look for.
5. **`/generate-llms-txt`** — generates the emerging llms.txt standard so AI crawlers know which of your docs/blog posts to ingest.

Install (free, MIT):
```
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

Then ask Claude "audit my site" or "how does my brand rank in ChatGPT vs Gemini?"

Repo: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer

Happy to dig into specifics if anyone wants to share their domain and we can demo it live.
