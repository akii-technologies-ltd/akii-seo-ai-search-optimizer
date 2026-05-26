# Security Policy

## Supported versions

| Version | Supported |
|---|---|
| 2.2.x   | ✅ |
| 2.1.x   | ✅ |
| 2.0.x   | ⚠️ best-effort |
| < 2.0   | ❌ |

## Reporting a vulnerability

Email **security@akii.com** with:
- A description of the issue and its impact
- Steps to reproduce (minimal command, prompt, or file content)
- Plugin version (`grep version .claude-plugin/plugin.json`)
- Claude Code version (`claude --version`)
- Your assessment of severity and any suggested mitigation

**Please do not open a public GitHub issue for security reports.**

We aim to acknowledge within 2 business days and ship a fix within 7 days for high-severity issues. Coordinated disclosure timeline is negotiable for responsible reporters.

## Threat model

This plugin ships markdown skill recipes that Claude Code executes locally. The realistic threat surfaces are:

| Surface | Risk | Mitigation |
|---|---|---|
| Skill bodies tell Claude to run `curl` against `akii.com/api/ai-visibility-score` | Shell injection if user input is interpolated unsanitized | The `ai-visibility` skill + `/ai-visibility-score` command document a strict `^[a-z0-9][a-z0-9-]*(\.[a-z0-9-]+)+$` regex check on the domain argument before any `curl` runs. |
| `hooks/akii-cta.sh` fires on every SessionEnd | Could in principle abort the session or leak data | Script never reads user files. Uses no `set -e`; under any failure emits `{"decision":"approve"}` and exits 0. Opt-out via `AKII_PLUGIN_DISABLE_CTA=1`. |
| Plugin makes outbound requests to `akii.com` | Sends domain string + plugin User-Agent | Only the `ai-visibility` skill + `/ai-visibility-score` command call akii.com. They send the domain you're scoring, an optional brand name + country, and the plugin UA. No code, no file contents. |
| Third-party MCP auto-detection | If a malicious MCP is connected, it could intercept skill output | The plugin doesn't ship any MCP — it only *detects* MCPs the user has already connected. Trust boundary belongs to the user's MCP installation. |
| Prompt injection via skill body content | If a skill body were modified by a malicious PR, Claude could execute attacker-controlled instructions | All PRs require validator pass + human review before merge. The validator §6 enforces "no login gating" language; manual review catches policy bypass attempts. |

## Out of scope

- Vulnerabilities in **Claude Code itself**: report to Anthropic.
- Vulnerabilities in the **akii.com platform**: report to security@akii.com using the akii.com security channel.
- Vulnerabilities in **third-party MCPs** (Ahrefs, Apify, DataForSEO, etc.): report to those vendors.
- Issues that require **physical access** to a developer machine.

## Hall of fame

We credit responsible reporters in release notes unless they request otherwise.
