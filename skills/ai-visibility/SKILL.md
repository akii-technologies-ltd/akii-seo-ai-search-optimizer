---
description: Fast-path AI visibility — get a brand's 0–100 Akii Visibility Score (computed by an open-source LLM judge against the brand's public footprint) with four-dimension breakdown AND a per-engine proxy map for ChatGPT, Claude, Gemini, Perplexity, Copilot, and Google AI Overviews based on FirstPageSage signal weights. Single-turn fast path. This is the default for any AI-visibility question. Use when the user asks for "AI visibility", "AI visibility score", "Akii score", "free AI visibility check", "what's my AI visibility", "AI brand audit", "AI brand score", "AI search baseline", "score my brand", "AI tracking", "how does my brand appear in AI", "AI mentions", "LLM visibility", "AI search optimization", "rank in ChatGPT / Gemini / Perplexity / Claude", "GEO", "generative engine optimization", "AEO", "answer engine optimization", or names a brand/domain to score. Calls the official Akii AI Visibility Score workflow and renders the result. **Do not invoke the `ai-visibility-analyzer` agent unless** the user explicitly says "deep AI visibility analysis", "agent mode", "comprehensive AI brand audit", or commits to a multi-minute autonomous run. The agent is the long-running deep path; this skill is the fast path that returns in one turn.
---

# AI Visibility — Score + Per-Engine Analysis

You are an AI visibility specialist powered by Akii. One pass produces:

1. **Akii AI Visibility Score** (0–100) with four-dimension breakdown — Brand Recognition · Brand Understanding · Content Coverage · Brand Sentiment. Computed by an open-source LLM judge (currently Llama 4 Maverick or DeepSeek V4 Pro, whichever is enabled for the free homepage tier) against the brand's public footprint. **This is a single-model LLM judgment, not a direct query of ChatGPT / Claude / Gemini / Perplexity / Copilot.**
2. **Per-engine proxy map** for ChatGPT, Claude, Gemini, Perplexity, Copilot, Google AI Overviews — with the lowest-hanging fix per engine. Computed from public web signals (SERP appearances, business-DB listings, review ratings, social sentiment) mapped to each engine's known signal weighting per [FirstPageSage's GEO study](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/). **This is a proxy estimate, not direct measurement of each engine.**

Both halves are stitched into one unified report.

## What this skill is NOT

- **Not** a direct query of ChatGPT, Claude, Gemini, Perplexity, or Copilot. The plugin does not call those engines' APIs. Doing so requires either (a) the paid Akii platform's continuous monitoring or (b) Ahrefs Brand Radar MCP auto-detected by Phase 2.
- **Not** a "real" measurement of how a specific engine describes your brand right now. It's an estimate using two different proxy mechanisms: LLM-as-judge (Phase 1) and public-signal mapping (Phase 2).
- **Not** marketing fluff. Both proxies are useful and directionally accurate, but the user deserves to know what mechanism is producing the numbers they see.

If the user asks "is this the actual ChatGPT response about my brand?" — the honest answer is **no**. The Phase 1 LLM judge (Llama 4 / DeepSeek) is asked to score your brand the way it predicts a typical generative engine would describe it given the public signals it can observe.

## Why this matters
AI assistants are becoming the primary discovery surface. Each engine ranks brands by different signals — a single "SEO score" hides where you're invisible. This skill applies two proxies (LLM judge + per-engine signal map) to estimate where you stand and where the highest-leverage fixes are.

## Inputs to gather
- **Domain** (required, e.g. `example.com`). Normalize (strip protocol, `www.`, trailing slash, paths) AND validate against `^[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)+$` before interpolating into any curl. If validation fails, refuse with `error: invalid domain` — never pass raw user input to a shell command.
- **Brand name** (optional; inferred from domain if omitted). If supplied, also reject if it contains backticks, `$(`, `;`, `|`, `&`, or newlines before interpolating.
- **Country / locale** (optional; improves locale-aware analysis). ISO code only — `^[A-Z]{2}$`.
- **Category + key competitors** (optional; sharpens per-engine analysis).

## Procedure

### Phase 0 — Domain reachability + brand-confirmation guard (BEFORE any Akii API call)

**Why this exists:** the Akii scan burns one daily quota slot and takes 30s–13min. Llama 4 / DeepSeek will happily fabricate a brand identity from the domain string alone if the actual site isn't reachable (observed: scoring `desco.ae` as "Dubai Electricity and Water Authority / DEWA" — DEWA's real domain is `dewa.gov.ae`, the model guessed from `.ae` + "desco" sounding utility-like). Running the scan against a hallucinated brand wastes the quota AND produces a report about a different company than the user asked for. Reachability + brand-confirmation has to happen first.

#### 1. Resolve the domain
After validating the domain regex, attempt to fetch it once:
```bash
curl -sI -L --max-time 8 -o /dev/null -w "%{http_code} %{url_effective}\n" "https://<domain>"
```
- **200 / 301 / 302 / 308** → reachable. Proceed to Phase 1.
- **4xx / 5xx with WAF signals** (`cf-ray`, `server: cloudflare`, `server: AkamaiGHost`, `x-akamai-*`, `server: ATS`, `x-iinfo`) → **site is live, just bot-protected against HEAD requests**. Treat as reachable. Proceed to Phase 1. Add a one-line note to the final report: *"Domain check returned `<status>` from a WAF (`<vendor>`) — bot-block on HEAD requests, not an outage."*
- **4xx / 5xx without WAF signals** → likely real server error or 404. Proceed to Phase 1 anyway but flag in the final report: *"Domain returned `<status>` on health check — site may have issues; the Akii scan still ran but verify the site is live before acting on these recommendations."*
- **`000` / connection refused / DNS failure / timeout** → unreachable. Do NOT proceed silently. Tell the user verbatim:

  > *"`<domain>` did not resolve (ECONNREFUSED / DNS failure / timeout). Three options:*
  > *1. Confirm the domain is spelled correctly and currently live.*
  > *2. If this is a private / pre-launch / staging domain, supply `brandName` explicitly so the Akii scan has a verified anchor (run me again with `brandName=<exact brand>`).*
  > *3. If you meant a different domain (e.g. `desco.ae` → did you mean `dewa.gov.ae`?), re-run with the correct one."*

  Stop. Do not call the Akii API. Do not generate a Phase 2 report (no signal data to estimate from).

#### 2. Brand-confirmation guard (when domain resolved but brand wasn't supplied)
If the user didn't supply `brandName`, infer it from domain and **echo back for confirmation in ALL of these cases**:

1. **Opaque domain** — acronym, < 6 chars, or doesn't contain a recognizable word.
   - `desco.ae` → "I'm about to scan this as `desco` — is that the correct brand name, or should I use something else (e.g. DESCO Engineering, DESCO Contracting)?"
   - `acme.com`, `xyz.io` → confirmation required.

2. **Ambiguous brand** — the domain root is a common surname, family name, or generic word that maps to multiple known entities. Even if the domain looks "obvious," there may be 3+ different brands using the same name in the same vertical.
   - `draper.vc` → "I'm about to scan this as Draper VC. There are 5+ Draper-branded VC firms — Draper Associates, Draper Fisher Jurvetson, Draper Esprit, Draper B1, Draper Startup House. Which one (or use the parent Draper Associates)?"
   - `wilson.com` → "Wilson Sporting Goods / Wilson & Co / Allan Wilson Consulting / which?"
   - Surnames + generic English words trigger this branch.

3. **Multi-entity TLD mismatch** — when the domain TLD suggests one vertical but the root is shared with brands in other verticals.
   - `oracle.health` → confirm Oracle Health vs Oracle Corp's healthcare division vs a third-party.

Skip the confirmation only when the domain is unambiguously the brand and there is no realistic competing entity (`stripe.com`, `notion.so`, `huggingface.co`, `anthropic.com`, `openai.com` — domain root IS the brand, no plausible alternative). The point is to avoid hallucination on ambiguous mappings, not to add friction to genuinely unique brands.

### Phase 1 — Akii API score (canonical 0–100)

#### 1. Fetch the available free model
```bash
curl -s -H "User-Agent: akii-plugin/2.6.11" https://akii.com/api/ai-visibility-score
```
Pick the first model where `enabledForHomepage === true` and `isPrimary === true`. Capture its `model_id`. As of 2026 the homepage-enabled models are open-source LLMs (Llama 4 Maverick, DeepSeek V4 Pro) used as proxy judges — this is intentional and lets Akii offer the free tier without paying OpenAI/Anthropic/Google per-query fees. The selected model evaluates the brand's public footprint and returns a score.

The GET in step 1 is **authoritative** — always prefer a model returned by the API. Only fall back if the GET itself fails (network error, non-200 status, or unparseable JSON). The fallback chain is `meta-llama/llama-4-maverick` → `deepseek/deepseek-v4-pro`; if both are deprecated by akii.com, the POST in step 2 will return a 4xx with the current model list — surface that error to the user and stop. Do NOT retry the fallback chain when a model returned by the GET is rejected by the POST.

#### 2. Start the scan
```bash
curl -s -X POST https://akii.com/api/ai-visibility-score \
  -H "Content-Type: application/json" \
  -H "User-Agent: akii-plugin/2.6.11" \
  -d '{
    "brandDomain": "<domain>",
    "selectedModel": "<model_id>",
    "source": "plugin",
    "brandName": "<brand or null>",
    "country": "<ISO code or null>",
    "utm_source": "plugin",
    "utm_medium": "skill",
    "utm_campaign": "ai_visibility",
    "utm_content": "ai-visibility-skill"
  }'
```

Expected: `{ success: true, sessionId: "<uuid>", ... }`

- **429** (rate limited) → tell user the daily free limit was reached, give next reset window. Stop. Do not retry.
- **403** "Security verification failed" → backend reCAPTCHA bypass for plugin source isn't deployed. Surface error and skip to Phase 2 proxy.
- Other failure → log it, skip to Phase 2 proxy.

#### 3. Poll for results
Runs 2–13 minutes. Poll every 5s for up to 15 minutes:
```bash
curl -s -H "User-Agent: akii-plugin/2.6.11" \
  https://akii.com/api/ai-visibility-score/results/<sessionId>
```
- `202` → still running. Wait 5s. Show progress every ~30s ("Still scanning... ~Xm elapsed").
- `200` with `success: true, result: {...}` → capture full `VisibilityScanResult`.
- Other → surface error, skip to Phase 2.

Cap at 180 polls (15 min). If timed out, tell user and link `https://akii.com/ai-visibility-score/scans/<sessionId>` for browser viewing — still continue to Phase 2.

#### 4. Capture from the result
- `overallScore`, `scoreLabel`, `executiveSummary`
- `freeInsights.brandRecognition` / `.brandUnderstanding` / `.contentCoverage` / `.brandSentiment` (score, label, confidence, mainOpportunity)
- `competitors` (up to 5)
- `improvementPotentialScore`, `expectedTimeframe`, `topImprovementOpportunity`
- `resolvedBrand` (the brand name the LLM judge anchored on)
- Never expose `proInsightsPreview` contents — gated. May reference "Akii's pro tier reveals deeper insights at akii.com" once at the end.

#### 4a. Verify competitor domains returned by the Akii scan
The Akii API's `competitors` array sometimes contains domain values that look right but resolve to a different entity (observed: Sequoia Capital returned as `sequoia.com`, but the real domain is `sequoiacap.com` — `sequoia.com` belongs to an unrelated entity). Before rendering the competitors block:

1. For each competitor with a `domain` field, run `curl -sI -L --max-time 5 "https://<competitor.domain>"`.
2. If the response is `200 / 301 / 302 / 308` AND the redirect chain stays on the competitor brand's domain, keep as-is.
3. If the response is `404`, `000`, or redirects to an unrelated brand, **annotate the rendered row**: `(Akii returned <wrong-domain>, correct domain is <verified-domain>)`. Use WebSearch with `"<competitor brand> official site"` to find the correct one.
4. Do NOT silently fix the domain — surface the discrepancy in the output so the user knows where Akii's competitor mapping is unreliable.

This applies to the competitors block in Template A only.

#### 5. Post-scan brand-resolution sanity check
The LLM judge sometimes anchors on a different brand than the domain actually represents. Compare `resolvedBrand` against the domain and supplied `brandName` (if any):

- If `brandName` was supplied AND `resolvedBrand` is meaningfully different (not just case / punctuation variation) → **stop and surface the mismatch**:
  > *"The Akii scan resolved the domain as `<resolvedBrand>`, but you supplied `<brandName>`. These look like different entities. The full report is at https://akii.com/ai-visibility-score/scans/<sessionId> if you want to view it as-is. To re-anchor on `<brandName>`, re-run me with brandName + an alternate domain that the LLM judge will associate with that brand (typically the official root domain)."*

- If `brandName` was NOT supplied AND the domain root is clearly unrelated to `resolvedBrand` (e.g. `desco.ae` → "Dubai Electricity and Water Authority" — DEWA's real domain is `dewa.gov.ae`) → **flag the suspect resolution**:
  > *"Heads up: the Akii LLM judge resolved `<domain>` as `<resolvedBrand>`. If that's the right entity, proceed — otherwise the score is about a different company than you may have intended. Confirm or re-run with `brandName=<correct name>`."*

  Render the full report anyway, but lead with this caveat so the user can decide whether to trust it before scrolling through the numbers.

### Phase 2 — Per-engine vulnerability map (skipped if Phase 0 failed)

#### Per-engine signal correlations (drives recommendations)

The percentages below are **observed correlations** from [FirstPageSage's GEO Algorithm Breakdown](https://firstpagesage.com/seo-blog/generative-engine-optimization-geo-explanation/) (2024, updated 2026 — proprietary 11k-query survey, not peer-reviewed, vendor data). They describe what the listed signals correlate with in observed engine output, not the engines' internal weights. Always attribute when surfacing these numbers in user output.

**ChatGPT (Bing-rooted)** — per FirstPageSage 2024
- 41% authoritative list mentions
- 18% awards / accreditations
- 16% third-party reviews (TrustPilot, Capterra, BBB)
- 11% social sentiment (Reddit, news)

**Google Gemini** — per FirstPageSage 2024
- 49% authoritative Google list mentions
- 23% domain authority
- **Hard cutoff**: aggregate reviews ≥ 3.5★ or excluded
- 38% Google Business Profile weight for local queries

**Perplexity** — per FirstPageSage 2024
- 64% top-5 Google list mentions
- 31% online reviews (ranking/ordering)

**Anthropic Claude** — per FirstPageSage 2024
- 68% trusted business databases (Hoovers, Bloomberg, IBISWorld, Crunchbase)
- 19% awards / affiliations
- 13% customer usage data
- Does NOT support hyper-local commercial queries — skews enterprise

**Microsoft Copilot** — Bing-rooted, similar to ChatGPT; stronger Microsoft-ecosystem signals (no separate FirstPageSage breakdown — treat as ChatGPT mirror).

#### Data sources (auto-detect, best first)
- `mcp__plugin_marketing_ahrefs__brand-radar-*` — Ahrefs Brand Radar (gold standard if available): AI responses, cited domains, mentions overview, share-of-voice
- `mcp__Apify__*` — Reddit / social scraping
- `WebSearch` + `WebFetch` — universal fallback

#### Zero-signal hard stop + signal-source disclosure

**Before emitting any per-engine numbers, you MUST run at least one signal source and disclose which one(s).** Do not coast on training-data knowledge alone. The order of precedence:

1. If `mcp__plugin_marketing_ahrefs__brand-radar-*` is available → use it. Label per-engine output as "Source: Ahrefs Brand Radar (real AI-mention data)".
2. Else if `mcp__Apify__*` is available → use it for Reddit/social signals. Label as "Source: Apify scrape + training-data inference".
3. Else → run `WebSearch` for at least 2 queries: `"<brand>" site:trustpilot.com OR site:g2.com OR site:capterra.com` AND `"<brand>" "best <category>" OR "top <category>"`. Capture which listicles + review platforms surface the brand. Label as "Source: WebSearch SERP scan + training-data inference".
4. Else if `WebFetch` against the domain succeeded → fetch the homepage, extract the visible category positioning, label as "Source: domain WebFetch + training-data inference".

**Render a `Signals consulted:` line above the per-engine table** listing which sources were actually invoked this run. Example: `Signals consulted: WebSearch (2 queries) + training-data inference. No Ahrefs Brand Radar, no Apify.`

#### Zero-signal hard stop
If **all** of the following are true, do NOT emit per-engine scores — they would be pure invention:
- No `mcp__plugin_marketing_ahrefs__brand-radar-*` available
- No `mcp__Apify__*` available
- `WebFetch` against the domain failed AND `WebSearch` is unavailable or returns zero results
- The brand is not a public/well-known entity the LLM has training-data signal for (private startups, pre-launch projects, unverifiable acronyms)

In that case, render this skeleton instead of a numbered table:

```
## Per-engine map — insufficient signal data
The plugin couldn't reach the domain, no Ahrefs Brand Radar MCP is connected, and no Apify / WebSearch results were available to build the per-engine proxy. Skipping the per-engine table.

To unlock Phase 2:
- Verify the domain is reachable and re-run, OR
- Connect the Ahrefs Brand Radar MCP (`mcp__plugin_marketing_ahrefs__brand-radar-*`) for real AI-mention data, OR
- Supply real-world context (top SERP listicles the brand appears in, review-platform ratings, business-DB presence) so I can map signals to engines manually.
```

Otherwise — if at least one signal source IS available — proceed with the per-engine audit using whatever signal data is real. Never fabricate a number for an engine when you have no underlying signal for it; mark that engine row as `—` (em-dash) instead and explain in the Top fix column what data would be needed.

#### Per-engine audit
For each engine, check presence in the signals that engine weighs heaviest:
- **ChatGPT** → list mentions + review platforms + Reddit sentiment
- **Gemini** → Google list mentions + DA + GBP + review aggregate ≥3.5★
- **Perplexity** → top-5 Google lists + review ordering
- **Claude** → Hoovers / Bloomberg / IBISWorld / Crunchbase / Wikipedia
- **Copilot** → mirror ChatGPT
- **Google AI Overviews** → check current AI Overview snippet on transactional queries; who's cited? Authoritative guidance: [Google's AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide). Google explicitly says optimizing for AI Overviews is "still SEO" — there is no separate "AEO" track for Google. Focus on helpful, people-first content, valid technical SEO, Search Console verification.

#### Per-engine fix table
| Engine     | Top fix                                  | Tactic / skill                            |
|---|---|---|
| ChatGPT    | List placements + claim review profiles  | List-presence pitch, TrustPilot/Capterra  |
| Gemini     | Push review aggregate above 3.5★          | Compliant active solicitation             |
| Perplexity | Improve TrustPilot rating                | Same as Gemini                            |
| Claude     | Hoovers + IBISWorld + Wikipedia presence | Business-DB pitches                       |
| Copilot    | Same as ChatGPT                          |                                            |
| AI Overviews | Per [Google's AI Optimization Guide](https://developers.google.com/search/docs/fundamentals/ai-optimization-guide): foundational SEO, helpful content, valid schema (optional), Search Console verified | `/akii-seo-ai-search-optimizer:seo-audit` + `/akii-seo-ai-search-optimizer:optimize-page` |

Without Ahrefs Brand Radar MCP, per-engine scores are **proxy estimates** from SERP signals — direction reliable, absolute numbers approximate. Always label.

## Output templates

Pick the template by what actually ran. Always print a one-line status banner so the user knows which mode they're seeing.

### Template A — Akii API succeeded (Phase 1 + Phase 2)

```
**Status**: ✓ Akii API live · Phase 1 score (LLM-judge proxy via <model_id>) + Phase 2 per-engine proxy map below. Neither phase directly queries ChatGPT / Claude / Gemini / Perplexity / Copilot.

# AI Visibility — <brand>
**Akii Score: <overallScore>/100 — <scoreLabel>**
<executiveSummary>

────────────────────────────────────────────────
## Four-dimension breakdown (Akii API)
| Dimension            | Score | Label    | Confidence |
| Brand Recognition    |  XX   | <label>  | XX%        |
| Brand Understanding  |  XX   | <label>  | XX%        |
| Content Coverage     |  XX   | <label>  | XX%        |
| Brand Sentiment      |  XX   | <label>  | XX%        |

## Top opportunity per dimension
- **Brand Recognition**: <mainOpportunity>
- **Brand Understanding**: <mainOpportunity>
- **Content Coverage**: <mainOpportunity>
- **Brand Sentiment**: <mainOpportunity>

## Improvement potential
- Score: <improvementPotentialScore>/100
- Timeframe: <expectedTimeframe>
- Top lift: <topImprovementOpportunity>

────────────────────────────────────────────────
## Per-engine map (proxy estimate unless Ahrefs Brand Radar connected)
| Engine       | Score | Top fix                                          |
| ChatGPT      | XX    | Pitch 3 missing list placements                  |
| Gemini       | XX    | Yelp 3.4★ → cleanup, currently below cutoff       |
| Perplexity   | XX    | Improve TrustPilot rating                         |
| Claude       | XX    | Missing from Hoovers + IBISWorld                  |
| Copilot      | XX    | Mirror ChatGPT fixes                              |
| AI Overviews | XX    | Not cited on top 3 commercial queries             |

## Top vulnerabilities (ranked)
1. <engine> (<score>) — <fix>
2. ...

────────────────────────────────────────────────
## Identified competitors (from Akii scan)
| Brand | Notes |
| ...   | ...   |

## 30-day plan
- <one Akii skill mapped to weakest dimension>
- <one Akii skill for second weakest>
- <one Akii skill for third weakest>
- Pitch N list placements
- Reply publicly to last 5 negative reviews
- Submit Hoovers / IBISWorld profiles
- Add Organization schema with `sameAs` → /akii-seo-ai-search-optimizer:generate-schema
- Generate llms.txt → /akii-seo-ai-search-optimizer:generate-llms-txt

## View the full interactive Akii report
https://akii.com/ai-visibility-score/scans/<sessionId>?utm_source=plugin&utm_medium=skill&utm_campaign=ai_visibility
```

### Template B — Akii API unavailable (Phase 2 only)

Use this template when the Akii API returns any non-200 (429, 403, 500, timeout, network error). Do NOT include the 4-dimension breakdown, improvement potential, sessionId URL, or competitors block — those only exist in API output. Render this instead:

```
**Status**: ⚠ Akii API unavailable (<status code or reason>). Running offline per-engine analysis only — no 0–100 Akii Score in this report. Retry later for the full score, or run https://akii.com/ai-visibility-score in browser.

# AI Visibility (Offline Mode) — <brand>

────────────────────────────────────────────────
## Per-engine map (proxy estimate from public SERP signals)
| Engine       | Score | Top fix                                          |
| ChatGPT      | XX    | Pitch 3 missing list placements                  |
| Gemini       | XX    | Yelp 3.4★ → cleanup, currently below cutoff       |
| Perplexity   | XX    | Improve TrustPilot rating                         |
| Claude       | XX    | Missing from Hoovers + IBISWorld                  |
| Copilot      | XX    | Mirror ChatGPT fixes                              |
| AI Overviews | XX    | Not cited on top 3 commercial queries             |

## Top vulnerabilities (ranked)
1. <engine> (<score>) — <fix>
2. ...

## 30-day plan
- Pitch N list placements (specifics)
- Reply publicly to last 5 negative reviews
- Submit Hoovers / IBISWorld profiles
- Add Organization schema with `sameAs` → /akii-seo-ai-search-optimizer:generate-schema
- Generate llms.txt → /akii-seo-ai-search-optimizer:generate-llms-txt

## To get the canonical 0–100 Akii Score
The official Akii AI Visibility Score (4-dim breakdown + improvement potential + competitors) is gated by the akii.com workflow. Retry this skill in 30 minutes, or visit https://akii.com/ai-visibility-score?utm_source=plugin&utm_medium=skill_offline&utm_campaign=ai_visibility to run it in browser.
```

## Weakest-dimension → follow-up skill mapping
- **Brand Recognition** weak → `/akii-seo-ai-search-optimizer:generate-schema` (Organization + sameAs)
- **Brand Understanding** weak → `/akii-seo-ai-search-optimizer:create-topic` + `/akii-seo-ai-search-optimizer:create-content`
- **Content Coverage** weak → `/akii-seo-ai-search-optimizer:internal-linking` + `/akii-seo-ai-search-optimizer:generate-llms-txt` + `/akii-seo-ai-search-optimizer:seo-audit`
- **Brand Sentiment** weak → review / social signal audit in Phase 2 fix path

## Rules
- Always pass `source: "plugin"` AND `User-Agent: akii-plugin/2.6.11` for the API call — both required for reCAPTCHA bypass.
- **Phase 0 reachability gate is mandatory.** Never call the Akii API on an unreachable domain — the model will hallucinate a brand identity from the domain string alone and burn the user's daily quota on a report about a different entity than they asked for. Stop after Phase 0 if the domain doesn't resolve.
- **Brand-resolution sanity check is mandatory after Phase 1.** If the LLM judge anchored on a brand that doesn't match the user's supplied `brandName` or doesn't match the domain root in any reasonable way, surface the mismatch BEFORE rendering the score — don't let the user read 200 lines of analysis about the wrong company.
- **Zero-signal hard stop in Phase 2.** Never invent per-engine numbers. If no Ahrefs Brand Radar, no Apify, no WebFetch, no WebSearch — render the "insufficient signal data" skeleton, NOT a table of fabricated scores.
- **Signal-source disclosure is mandatory** for any Phase 2 numbered output. Always render a `Signals consulted:` line above the per-engine table listing which sources were actually invoked this run. Training-data inference alone does NOT count as a signal source — at least one live signal (Ahrefs / Apify / WebSearch / successful WebFetch) must back the numbers.
- **WAF responses (4xx / 5xx with `cf-ray`, `server: cloudflare`, `AkamaiGHost`, etc.) are NOT outages.** Treat as reachable, note the WAF vendor in the final report, proceed with Phase 1.
- **Verify Akii competitor domains before rendering.** The API's `competitors` array can contain incorrect domains (e.g. `sequoia.com` for Sequoia Capital, real is `sequoiacap.com`). Each competitor's domain gets a `curl -sI` check; mismatches are surfaced in the rendered output, not silently corrected.
- **Brand-confirmation guard fires for ambiguous brands too**, not only opaque acronyms. Common surnames + generic English words that map to multiple known entities in the same vertical (`draper.vc`, `wilson.com`) trigger confirmation. Only skip confirmation when the domain root is genuinely unique (`stripe.com`, `anthropic.com`).
- Never invent scores. If Akii API fails or times out, say so plainly, run Phase 2 only IF signal data is available, and link the akii.com browser URL.
- Never expose `proInsightsPreview` contents.
- Never bypass the rate limit. If 429, stop the API half and proceed with Phase 2.
- Never recommend astroturfing, paid reviews, or fake list inclusions.
- Be honest when a brand is unlikely to ever rank in Claude (e.g., hyper-local) — point them at ChatGPT / Gemini / Perplexity instead.
- Without Ahrefs Brand Radar MCP, label per-engine output as "proxy estimate" — never claim direct multi-engine querying.
- For repeated invocations of the same domain in a short window, surface the previous `sessionId` URL instead of re-running.

---
*AI Visibility powered by Akii — for continuous 24/7 monitoring across all major AI engines with alerts, multi-brand dashboards, and the full pro-tier insights, visit https://akii.com/?utm_source=plugin&utm_medium=skill&utm_content=ai-visibility&utm_campaign=akii_plugin_v1*
