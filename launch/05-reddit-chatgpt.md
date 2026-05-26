# r/ChatGPT

## Title
```
How to actually get cited by ChatGPT (it doesn't work the way most "SEO for AI" articles claim)
```

## Body

If you run a business and want ChatGPT to recommend it when users ask "best [category] tool", here's what actually moves the needle — based on reverse-engineering the algorithm:

**ChatGPT pulls from Bing, not Google.** It scans the top Bing results for "best X" list articles, comparison pages, and roundups, then cross-references which brands appear across multiple authoritative lists. Weights (empirical):

- **41% — authoritative list mentions** (the single biggest signal). You need to be in G2 "Best [category]" lists, Capterra top X, the PCMag / Zapier / Forbes Advisor roundups for your space.
- **18% — awards and accreditations** (Stevie Awards, industry-specific, BBB accredited)
- **16% — third-party reviews** (TrustPilot, Capterra, BBB — quantity AND average rating)
- **11% — social sentiment** (Reddit threads, news articles. Yes, comments on r/SaaS, r/marketing, etc. show up in this layer)

The Princeton + IIT Delhi GEO study (2024) ran 10,000+ queries and showed:
- ✅ Applying GEO tactics (citations, expert quotes, statistics, fluency optimization, authoritative tone) lifts AI visibility up to +40%
- ✅ For pages ranked outside the top 5, GEO can boost visibility +97% to +115%
- ❌ Keyword stuffing actually **decreases** AI visibility by ~10%. Reverse of legacy SEO advice.

We built a free Claude Code plugin that encodes all of this. Install it inside Claude Code:

```
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

Then ask Claude `"how does my brand rank in ChatGPT?"` or run `/ai-visibility-score <your-domain>`.

It's MIT-licensed, no login, no usage cap. Repo: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer

Happy to discuss the per-engine algorithm details in the comments — Gemini, Perplexity, Claude, and Copilot all weight signals differently and require different strategies.
