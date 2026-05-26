# HackerNews — Show HN

## Title (80 char limit, target ~70)
```
Show HN: Akii – Free SEO + AEO + GEO toolkit for Claude Code
```

## URL field
```
https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer
```

## Text body (post in the body field, optional but recommended for context)

Hi HN — we just open-sourced an SEO + AEO + GEO toolkit as a Claude Code plugin. Free, MIT, no login, no usage cap. Built for the problem that the SERP is no longer the only place buyers find you: ChatGPT, Claude, Gemini, Perplexity, Copilot, and Google AI Overviews each rank brands by different signals, and most SEO tools haven't caught up.

What's in it:

- **13 skills** that auto-trigger from natural language (`"audit my site"`, `"why am I not in ChatGPT?"`, `"generate llms.txt"`, etc.)
- **8 slash commands** including `/ai-visibility-score <domain>` which calls the same workflow that powers akii.com's homepage tool — returns a real 0–100 score across 4 dimensions (recognition, understanding, content coverage, sentiment)
- **5 autonomous agents** for end-to-end audits, content strategy, competitor analysis
- **Princeton GEO method** encoded in the `optimize-page` skill (--mode=geo) — the study showed up to +40% AI visibility lift (+115% for pages currently outside the top 5); keyword stuffing actually decreases visibility ~10%
- **Per-engine algorithm awareness** — encodes empirical signal weights (ChatGPT 41% on authoritative lists, Gemini hard cutoff at 3.5★, Claude 68% on Hoovers/Bloomberg/IBISWorld, etc.)
- **Auto-detects your existing Ahrefs / GSC / Apify / DataForSEO MCPs** — if you already pay for them, the skills use them for real data; otherwise falls back to WebSearch/WebFetch

Install:
```
/plugin marketplace add akii-technologies-ltd/akii-seo-ai-search-optimizer
/plugin install akii-seo-ai-search-optimizer@akii
```

Then ask Claude `"audit my site"` or run `/ai-visibility-score example.com`.

We built this because we kept seeing SaaS founders rank #1 on Google but be completely invisible inside ChatGPT (because ChatGPT doesn't read Google — it reads Bing list articles + reviews). The four big AI engines have wildly different algorithms; we encoded that into the plugin.

Repo: https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer
Landing: https://akii.com/claude-code

Happy to answer anything about the architecture, the Princeton GEO research, why we shipped it as a Claude Code plugin instead of a SaaS, or anything else.

---

## Engagement plan
- Reply within 4h to every comment for the first 24h
- Have ready: 1 GIF demo, link to the Princeton paper, install command, comparison table
- DO NOT brigade — never ask friends to upvote
- Repost at most once 90 days from now ONLY if first attempt got <5 points within 2h
