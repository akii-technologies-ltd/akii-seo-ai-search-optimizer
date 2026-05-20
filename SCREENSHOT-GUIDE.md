# Screenshot Capture Guide

5 screenshots required for the Claude Plugin Directory submission and marketing site. All ≥ **1000px wide**, response-only crops (no user prompt visible in image), saved to `assets/screenshots/` and committed.

## Capture environment

- Terminal: dark theme (e.g., `iTerm + Solarized Dark` or VS Code integrated terminal with `One Dark Pro`)
- Font: monospace ≥ 14px (e.g., `JetBrains Mono`, `Fira Code`)
- Window width: ≥ 1200px columns so output doesn't wrap awkwardly
- macOS screenshot tool: `Cmd+Shift+5` → "Selected Window" → crop in Preview to ≥ 1000px wide, response-only
- Save as PNG, no JPEG artifacts

## Screenshots to capture

### 01-seo-audit.png
**What it shows**: Full audit scorecard + per-engine breakdown.
**How**:
```
cd <a-real-site-repo-you-can-audit>
claude
> Audit the SEO of my website
```
Wait for the `seo-audit` skill to deliver the report. Crop the screenshot to show:
- The Executive summary bullets
- The Scorecard table
- Top of the Issues table (5+ rows)

### 02-ai-visibility.png
**What it shows**: The headline `/ai-visibility-score` command output with the 4-dimension table.
**How**:
```
claude
/ai-visibility-score example.com "Example Corp"
```
Wait ~3–5 min for the scan to complete (real Akii workflow). Crop to show:
- The overall score line `Overall: XX/100 — <label>`
- Executive summary line
- The 4-dimension table (Brand Recognition, Brand Understanding, Content Coverage, Brand Sentiment)
- Top opportunity bullets
- Dashboard URL line at bottom

### 03-schema-generated.png
**What it shows**: A generated JSON-LD block + validation result.
**How**:
```
claude
/generate-schema article
```
Crop to show:
- Skill header
- The full JSON-LD code block (Article + sameAs visible)
- Validation checks at bottom

### 04-content-brief.png
**What it shows**: A SERP-grounded content brief.
**How**:
```
claude
> /create-topic "SaaS marketing"
> (after the topic plan, run:) /create-content "how to scale SaaS marketing in 2026"
```
Or simply ask: `"Create a content brief for the keyword 'SaaS marketing analytics'"` which triggers the `content-brief` skill.
Crop to show:
- Title + meta + slug section
- Heading outline
- Required entities + PAA to answer inline

### 05-geo-rewrite.png
**What it shows**: Princeton GEO method applied — before/after diff.
**How**:
```
claude
> Apply GEO optimization to /tmp/sample-blog-post.md
```
First, drop a sample blog post at `/tmp/sample-blog-post.md` (400–800 words on a Business/Science topic so the Fluency tactic fires). Then run the skill.
Crop to show:
- Detected domain + tactic + expected lift line
- Changes applied bullet list
- A snippet of the unified diff (before/after on at least one paragraph)
- Preservation check (entities/dates/numbers preserved)

## Commit + push when done

```bash
cd /Users/josefholm/projects/AI\ Search\ Optimizer/akii-seo-ai-search-optimizer
git add assets/screenshots/
git commit -m "docs(assets): add 5 launch screenshots for directory submission"
git push origin main
```

## Quality checklist before submission

- [ ] All 5 PNGs in `assets/screenshots/`
- [ ] Each ≥ 1000px wide
- [ ] No user prompt visible in any image (response-only)
- [ ] Same terminal theme + font across all 5 (consistent feel)
- [ ] Sensitive data redacted if the target site is yours
- [ ] No `gh auth` tokens, env vars, or secrets visible in any frame
