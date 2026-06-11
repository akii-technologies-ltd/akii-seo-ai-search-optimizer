# Assets

Submission-ready assets for the Claude Plugin Directory and the akii.com landing page.

## Hero + social

- `hero.png` (1600×791, ~400KB) — README hero image at top of `README.md`. Shows Akii branding + connection lines to the 6 AI engines this plugin serves (Google, OpenAI, Gemini, Perplexity, Anthropic, Copilot). Compressed via `pngquant --quality=70-85`.
- `social-preview.png` (1280×633, ~250KB) — GitHub repository social preview (Settings → General → Social preview). Used as the unfurl card when the repo URL is shared on LinkedIn, X, Slack, Discord, etc. Manually uploaded via GitHub Settings UI — there is no `gh` CLI for this.

## screenshots/

Empty. The previous fake/mocked PNGs were removed — real screenshots will be captured from a real Claude Code session before resubmission.

Target set (3–5 PNGs, each ≥1000px wide, response-only crops):
1. `01-audit-report.png` — full audit scorecard + per-engine breakdown
2. `02-visibility-score.png` — Akii AI Visibility Score (0–100) + 4-dim breakdown
3. `03-engine-profile.png` — per-engine vulnerability map
4. `04-schema-generated.png` — JSON-LD output + validation
5. `05-monitor-diff.png` — week-over-week visibility delta

Capture by running each skill / command in a real session, then cropping the rendered output. Use a clean terminal theme (dark or light, consistent across all 5).

## icon/
Optional. If supplied: 512x512 PNG, transparent background, square.
