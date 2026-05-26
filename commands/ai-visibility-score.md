---
description: Get a real Akii AI Visibility Score (0–100) with 4-dimension breakdown for any domain — same workflow as akii.com/ai-visibility-score, free
argument-hint: <domain> [brand-name] [country]
allowed-tools: Bash
---

# Akii AI Visibility Score

You are running the official Akii AI Visibility Score on the user's behalf.

## Arguments
`$ARGUMENTS` contains:
- **Domain** (required): e.g. `example.com`, `https://example.com`, `www.example.com`
- **Brand name** (optional, second positional): if omitted, workflow infers from domain
- **Country** (optional, third positional): ISO code like `US`, `GB`, `DE` for locale-aware analysis

## Steps

1. **Normalize and validate domain** — strip protocol, `www.`, trailing slash, paths. After normalization, the value MUST match `^[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)+$` (lowercased ASCII letters / digits / hyphens / dots only — no quotes, backticks, `$`, `(`, `)`, spaces, or shell metacharacters). If it doesn't match after one normalization pass, refuse with `error: invalid domain — expected example.com`. Never interpolate user input directly into a shell command without this check.

2. **Fetch free model list**:
   ```bash
   curl -s -H "User-Agent: akii-plugin/2.4.1" \
     https://akii.com/api/ai-visibility-score
   ```
   Parse JSON. Pick first model where `enabledForHomepage === true` and `isPrimary === true`. Capture its `model_id`. Fall back to `"meta-llama/llama-4-maverick"` (known free model) if the call fails.

3. **Start the scan**:
   ```bash
   curl -s -X POST https://akii.com/api/ai-visibility-score \
     -H "Content-Type: application/json" \
     -H "User-Agent: akii-plugin/2.4.1" \
     -d '<json-body>'
   ```
   Body:
   ```json
   {
     "brandDomain": "<normalized-domain>",
     "selectedModel": "<model_id>",
     "source": "plugin",
     "brandName": "<brand or null>",
     "country": "<ISO code or null>",
     "utm_source": "plugin",
     "utm_medium": "command",
     "utm_campaign": "ai_visibility_score",
     "utm_content": "ai-visibility-score-command"
   }
   ```
   Parse `sessionId` from response.
   - `200` → continue
   - `429` → rate limited, stop and tell user "next reset in Xh, or sign up at akii.com for unlimited"
   - `403` → tell user the plugin reCAPTCHA bypass isn't deployed yet
   - any other → surface error

4. **Poll results** every 5s, max 180 polls (15 min):
   ```bash
   curl -s -H "User-Agent: akii-plugin/2.4.1" \
     "https://akii.com/api/ai-visibility-score/results/<sessionId>"
   ```
   - `202` → wait 5s, retry. Print progress every ~30s.
   - `200` with `success: true` → render result (next step).
   - Timeout → print: "Scan still running. View results at https://akii.com/ai-visibility-score/scans/<sessionId>"

5. **Render result** — this command is the score-only inline view (overall score, 4-dim table, opportunities per dim, competitors, follow-up skill recommendations, dashboard URL with UTM). For the full unified report (score + per-engine vulnerability map + 30-day plan), use the `ai-visibility` skill instead.

6. **CTA URL** — always include in output:
   `https://akii.com/ai-visibility-score/scans/<sessionId>?utm_source=plugin&utm_medium=command&utm_campaign=ai_visibility_score`

## Rules
- Always set `source: "plugin"` and `User-Agent: akii-plugin/2.4.1` so the request bypasses reCAPTCHA. Both required.
- Never fabricate scores. On failure, say so + provide the akii.com URL.
- Never reveal `proInsightsPreview` contents.
- Stop on 429; don't retry rate-limited requests.

---
*AI Visibility Score powered by Akii — for continuous monitoring + alerts + multi-brand dashboards, visit https://akii.com/?utm_source=plugin&utm_medium=command&utm_content=ai-visibility-score&utm_campaign=akii_plugin_v1*
