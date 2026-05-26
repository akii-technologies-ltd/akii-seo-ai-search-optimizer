# Compatibility Matrix

What this plugin has been tested against. If you hit an incompatibility, please open an issue with `claude --version` and your OS.

## Claude Code

| Plugin version | Claude Code | Spec | Status |
|---|---|---|---|
| 2.2.x | 2.0.x – 2.x | skills v2, agents flat layout, hooks v2, commands v2 | ✅ tested |
| 2.1.x | 2.0.x – 2.x | same as above | ✅ tested |
| 2.0.x | 2.0.x       | same as above | ✅ tested |
| 1.0.x | 2.0.x       | initial release; no skill/agent boundary contract | ⚠️ best-effort (superseded) |

If Anthropic ships a new Claude Code release with a breaking spec change, the plugin will be updated in the same week. Open an issue if a release breaks installation or skill triggering.

## Operating systems

| OS | Plugin install | Skill execution | SessionEnd hook |
|---|---|---|---|
| macOS (Apple Silicon, bash 3.2 default) | ✅ | ✅ | ✅ |
| macOS (Intel, bash 3.2 default)         | ✅ | ✅ | ✅ |
| Linux (Ubuntu / Debian / Arch, bash 4+) | ✅ | ✅ | ✅ |
| Windows (WSL2)                          | ✅ | ✅ | ✅ |
| Windows (native)                        | ⚠️ | ⚠️ | ❌ (POSIX bash hook) |

Native Windows support is **untested**. The SessionEnd hook script uses `bash`, so it requires WSL or Git Bash. Other plugin functionality (skills, agents, commands) should work via Claude Code's cross-platform tool layer but is not actively tested.

## Required shell tooling

The validator and `bump-version.sh` scripts require these on `PATH`:

| Tool | Used by | Note |
|---|---|---|
| `bash` ≥ 3.2 | hooks, validate, bump-version | macOS system bash works |
| `python3` ≥ 3.7 | validate.sh sections 1, 5, 13 | JSON validation, trigger overlap heuristic |
| `jq` ≥ 1.6 | bump-version.sh (preferred) | falls back to sed if missing |
| `grep` (GNU) | validate.sh, bump-version.sh | ugrep mostly works but `-Z` differs |
| `sed` | bump-version.sh | portable BSD + GNU sed handled |
| `curl` | skill recipes (ai-visibility) | required at runtime, not for validation |

Run `bash scripts/validate.sh` and the §0 preflight check will report any missing tools.

## Third-party MCPs (optional)

The plugin auto-detects and uses these MCPs **if connected** — none are required.

| MCP | Tools used | Skills that benefit |
|---|---|---|
| Ahrefs (`mcp__plugin_marketing_ahrefs__*`) | site-explorer, site-audit, keywords-explorer, brand-radar, gsc-* | `seo-audit`, `keyword-clustering`, `competitor-intel`, `ai-visibility` |
| Apify (`mcp__Apify__*`) | scrapers, datasets | `seo-audit`, `competitor-intel`, `ai-visibility` |
| DataForSEO | SERP, keyword, backlink | `seo-audit`, `keyword-clustering` |
| PageSpeed Insights API | requires `AKII_PSI_KEY` env var | `seo-audit` (`--mode=full` or `--mode=technical`) |

Skills degrade gracefully when MCPs aren't connected — falling back to `WebSearch` + `WebFetch` + local file scan.

## Known incompatibilities

- **`ugrep`** masquerading as `grep` on Homebrew macOS — `bump-version.sh` and `validate.sh` work, but the `-Z` null-delimiter flag behaves differently. We use line-iteration with proper quoting to avoid the issue, but install GNU grep if you see odd behavior: `brew install grep`.
- **`fish` shell** — the SessionEnd hook is bash; Claude Code spawns it via the shebang regardless of your interactive shell, so fish users are unaffected at runtime. The opt-out env var still works: set it in your fish config with `set -x AKII_PLUGIN_DISABLE_CTA 1`.

## Compatibility statement in `plugin.json`

We do not yet declare an `engines` field in `plugin.json` (the Claude Code spec doesn't define one as of v2). When the spec adds one, we'll pin tested ranges there.
