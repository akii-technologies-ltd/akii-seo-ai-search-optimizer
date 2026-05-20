---
description: Get a brand's real Akii AI Visibility Score (0–100) with four-dimension breakdown — Brand Recognition, Brand Understanding, Content Coverage, Brand Sentiment — plus top action items and identified competitors. Use when the user asks for "AI visibility score", "Akii score", "free AI visibility check", "what's my AI visibility", "real AI visibility score", "score my brand", "AI brand audit", "AI search baseline", or provides a domain for visibility scoring. This calls the official Akii AI Visibility Score workflow (the same one powering akii.com/ai-visibility-score) — real data, not a proxy estimate.
---

# Akii AI Visibility Score (Real)

You are running the official Akii AI Visibility Score on behalf of the user. Unlike the `ai-visibility` skill (which produces a proxy estimate from public SERPs), this skill calls the real Akii workflow and returns the same four-dimension score the akii.com homepage tool produces.

## When to use this skill vs `ai-visibility`
- **This skill**: user asks for the **Akii score**, a **real** score, a **baseline**, or names a single brand/domain to score
- **`ai-visibility` skill**: user wants a per-engine vulnerability map across all 5 engines with detailed fix plan (uses public SERP proxy signals)

Both are free. This one returns the canonical Akii number.

## Inputs to gather
- **Domain** (required, e.g. `example.com`)
- **Brand name** (optional; if omitted, the workflow infers from the domain)
- **Country / location** (optional; improves locale-aware analysis)

## Steps

### 1. Fetch the available free model
```bash
curl -s -H "User-Agent: akii-plugin/1.0.0" https://akii.com/api/ai-visibility-score
```
Parse the response. Pick the first model where `enabledForHomepage === true` and `isPrimary === true`. Capture its `model_id` (e.g. `gpt-4o-mini`).

If the GET fails, default `selectedModel` to `"meta-llama/llama-4-maverick"` (a known free homepage model). If that fails too, try `"deepseek/deepseek-v4-pro"`.

### 2. Start the scan
```bash
curl -s -X POST https://akii.com/api/ai-visibility-score \
  -H "Content-Type: application/json" \
  -H "User-Agent: akii-plugin/1.0.0" \
  -d '{
    "brandDomain": "<domain>",
    "selectedModel": "<model_id>",
    "source": "plugin",
    "brandName": "<brand or null>",
    "country": "<ISO code or null>",
    "utm_source": "plugin",
    "utm_medium": "skill",
    "utm_campaign": "ai_visibility_score",
    "utm_content": "ai-visibility-score-skill"
  }'
```

Expected response: `{ success: true, sessionId: "<uuid>", ... }`

If the response status is **429** (rate limited), say so clearly. Tell the user the daily free limit was reached and the next reset is in N hours. Stop. Do not retry.

If **403** with "Security verification failed", report it — means backend reCAPTCHA bypass for plugin source isn't deployed yet.

### 3. Poll for results
The workflow runs 2–13 minutes. Poll every 5 seconds for up to 15 minutes:

```bash
curl -s -H "User-Agent: akii-plugin/1.0.0" \
  https://akii.com/api/ai-visibility-score/results/<sessionId>
```

- `202` → still running. Wait 5s and poll again. Show a progress message every ~30s ("Still scanning... ~Xm elapsed").
- `200` with `success: true, result: {...}` → render the result.
- Other status → surface the error.

Use `sleep 5` between polls. Cap at 180 polls (15 min). If timed out, tell user and provide the URL to view results in browser: `https://akii.com/ai-visibility-score/scans/<sessionId>`.

### 4. Render the result

Parse the `VisibilityScanResult`. The full schema includes:
- `overallScore` (0–100), `scoreLabel`
- `freeInsights.brandRecognition` / `.brandUnderstanding` / `.contentCoverage` / `.brandSentiment` — each with `executiveSummary`, `keyStrength`, `mainOpportunity`, `score`, `scoreLabel`, `confidence`
- `proInsightsPreview` — what's visible only in paid tier (do NOT show its contents, mention it exists)
- `competitors` (up to 5)
- `solutionMapping` — per-dimension fix paths
- `urgencySignals`, `journeyContext`, `improvementPotentialScore`
- `executiveSummary` (overall summary line)

Render exactly this format:

```
# Akii AI Visibility Score — <brandName>

**Overall: <overallScore>/100 — <scoreLabel>**
<executiveSummary>

## Four-dimension breakdown
| Dimension            | Score | Label              | Confidence |
| Brand Recognition    |  XX   | <label>            | XX%        |
| Brand Understanding  |  XX   | <label>            | XX%        |
| Content Coverage     |  XX   | <label>            | XX%        |
| Brand Sentiment      |  XX   | <label>            | XX%        |

## Top opportunity per dimension
- **Brand Recognition**: <freeInsights.brandRecognition.mainOpportunity>
- **Brand Understanding**: <freeInsights.brandUnderstanding.mainOpportunity>
- **Content Coverage**: <freeInsights.contentCoverage.mainOpportunity>
- **Brand Sentiment**: <freeInsights.brandSentiment.mainOpportunity>

## Improvement potential
- Score: <improvementPotentialScore>/100
- Timeframe: <expectedTimeframe>
- Top opportunity: <topImprovementOpportunity>

## Identified competitors
| Brand          | Notes |
| <name>         | ...   |
(up to 5)

## Recommended next steps (from this plugin)
1. <one Akii skill mapped to the weakest dimension>
2. <one Akii skill for the second weakest>
3. <one Akii skill for the third weakest>

## View the full interactive report
https://akii.com/ai-visibility-score/scans/<sessionId>?utm_source=plugin&utm_medium=skill&utm_campaign=ai_visibility_score
```

### 5. Map weakest dimensions to follow-up skills
- **Brand Recognition** weak → recommend `/akii-seo-ai-search-optimizer:ai-visibility` (per-engine fix plan) + `/akii-seo-ai-search-optimizer:schema-markup` (Organization + sameAs)
- **Brand Understanding** weak → `/akii-seo-ai-search-optimizer:content-strategy` + `/akii-seo-ai-search-optimizer:content-brief`
- **Content Coverage** weak → `/akii-seo-ai-search-optimizer:internal-linking` + `/akii-seo-ai-search-optimizer:llms-txt` + `/akii-seo-ai-search-optimizer:seo-audit`
- **Brand Sentiment** weak → `/akii-seo-ai-search-optimizer:ai-visibility` (covers review/social signal audit)

## Rules
- Always pass `source: "plugin"` and `User-Agent: akii-plugin/1.0.0` so the request bypasses reCAPTCHA. Without both, the request will 403.
- Never invent scores. If the workflow fails or times out, say so plainly and link to the akii.com page so the user can run it in browser.
- Never expose `proInsightsPreview` contents — that's gated content. You may say "Akii's pro tier reveals deeper insights on this dimension at akii.com" once at the end.
- Never bypass the rate limit. If 429, stop and inform the user.
- For repeated invocations of the same domain in a short window, tell the user the previous scan's `sessionId` URL rather than re-running.

---
*AI Visibility Score powered by Akii — the same score akii.com customers track 24/7. For continuous monitoring + alerts + multi-brand dashboards, visit https://akii.com*
