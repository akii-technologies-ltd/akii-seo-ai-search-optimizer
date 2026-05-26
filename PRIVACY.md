# Privacy

This document describes exactly what data the **Akii — SEO & AI Search Optimizer** plugin sends off your machine, when it sends it, and how to turn it off.

## What the plugin collects

The plugin sends a single anonymized HTTP POST to `https://akii.com/api/plugin-telemetry` **at most once per machine per 24 hours**, from the SessionEnd hook (`scripts/akii-cta.sh`).

The full payload is:

```json
{
  "plugin_version": "2.9.0",
  "session_hash": "<16-hex-char sha256 prefix>",
  "os": "Darwin",
  "timestamp": "2026-05-27T18:00:00Z"
}
```

That is the entire payload. Nothing else is sent.

### Field-by-field

| Field | What it is | What it is NOT |
|---|---|---|
| `plugin_version` | The plugin version installed (read from `.claude-plugin/plugin.json`) | Not a per-user version. Identical for every install on the same version. |
| `session_hash` | The first 16 hex characters of `sha256("akii-plugin-<machine UUID>")` where the machine UUID comes from `IOPlatformUUID` (macOS), `/etc/machine-id` (Linux), or `uname -n` + `uname -m` as fallback | NOT reversible to a username, email, IP address, or any other PII. Stable per machine — so we can count unique installs across daily reports — but not linkable to any individual. |
| `os` | The output of `uname -s` — typically `Darwin`, `Linux`, or `MINGW64_NT-*` for WSL | Not your OS version, not your CPU architecture, not your hostname. |
| `timestamp` | Current UTC time in ISO 8601 | Not your local timezone, not session length, not how long any skill ran. |

### What the plugin does NOT collect

- **No code**. The plugin never reads or transmits the contents of any file in your project.
- **No file paths**. No absolute paths, relative paths, or directory names from your project ever leave your machine via this hook.
- **No prompts**. Nothing you typed to Claude is transmitted.
- **No skill outputs**. Nothing the plugin generated is transmitted.
- **No audited domains or URLs**. If you ran `/akii-seo-ai-search-optimizer:ai-visibility` on `example.com`, the domain `example.com` is NOT included in the telemetry payload.
- **No bash command strings**. Unlike the Vercel Claude Code plugin incident reported in [TechRadar](https://www.techradar.com/pro/that-felt-wrong-dev-uses-claude-to-expose-why-a-popular-no-code-platform-wants-to-read-all-your-prompts), this plugin does not capture bash command strings or environment variables.
- **No IP address logging beyond standard HTTP**. The `akii.com` endpoint does not store the source IP — only the four fields above.
- **No skill invocation tracking**. The telemetry hook cannot tell which (if any) plugin skills you ran during the session.

### Why this minimal set?

To answer four questions:

1. **How many people install the plugin?** (Count of unique `session_hash` values over a window.)
2. **How many people actively use it?** (Same count, daily/weekly/monthly active.)
3. **Which versions are people running?** (Distribution of `plugin_version`.)
4. **Which OSes does the install base run on?** (Distribution of `os` — to know which OS-specific bugs matter most.)

Nothing in the payload is required for any other purpose.

## When the plugin sends data

- **At SessionEnd**, after Claude Code finishes a session that loaded this plugin.
- **At most once per 24 hours per machine.** A local cache file at `~/.cache/akii-plugin/telemetry-last` (or `$XDG_CACHE_HOME/akii-plugin/telemetry-last`) tracks the last POST time. The next SessionEnd within 24h skips the POST.
- **As a fire-and-forget background HTTP request** with a 4-second total timeout. Your session ends immediately regardless of network state.
- **Never during plugin install, update, or skill invocation.** Only at SessionEnd.

## How to turn it off

Any one of these disables the telemetry POST. They are checked in order; the first one that matches wins.

| Env var | Effect |
|---|---|
| `AKII_PLUGIN_DISABLE_TELEMETRY=1` | Plugin-specific opt-out. Disables telemetry only — CTA + version nudge still run. |
| `AKII_PLUGIN_DISABLE_CTA=1` | Disables the entire SessionEnd hook (CTA + version nudge + telemetry). |
| `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` | Anthropic's standard universal kill switch for nonessential plugin and CLI traffic. Honored by this plugin. |
| `DO_NOT_TRACK=1` | Web standard for telemetry opt-out. Honored by this plugin. |

To make any of these permanent, add the export to your shell profile (`~/.zshrc`, `~/.bashrc`, etc.) or to your Claude Code `settings.json`:

```json
{
  "env": {
    "AKII_PLUGIN_DISABLE_TELEMETRY": "1"
  }
}
```

## Default-off cases

The plugin is **default-off** (sends nothing without explicit opt-in via env var) when Claude Code is run against any of these commercial providers, matching Anthropic's own posture for these surfaces per [code.claude.com/docs/en/data-usage](https://code.claude.com/docs/en/data-usage):

- `CLAUDE_CODE_USE_BEDROCK=1` — Amazon Bedrock
- `CLAUDE_CODE_USE_VERTEX=1` — Google Cloud Vertex AI
- `CLAUDE_CODE_USE_FOUNDRY=1` — Microsoft Azure Foundry
- `CLAUDE_CODE_USE_ANTHROPIC_AWS=1` — Claude Platform on AWS

If you are an enterprise user on one of these providers, no telemetry leaves your machine from this plugin unless you explicitly opt in.

## What akii.com does with the data

Aggregated only. The `akii.com/api/plugin-telemetry` endpoint writes each event to a Supabase table. Akii then queries that table to produce:

- Daily / weekly / monthly active install counts (unique `session_hash` per window)
- Version distribution per day (which `plugin_version` values are still active)
- OS distribution (Darwin vs Linux vs other)

The raw rows are retained for 90 days, then aggregated into daily summary rows and the per-row data is deleted. Aggregates contain only counts and percentages — no `session_hash` values.

We do not share, sell, or otherwise distribute this data to any third party.

## Verifying for yourself

The full telemetry implementation is in [`scripts/akii-cta.sh`](./scripts/akii-cta.sh) (search for `Telemetry POST`). Every line that touches the network or the cache is in that one file — there is no helper binary, no obfuscated code, no shared library, and no second hook.

Read it. Run it under `bash -x` to trace each step. If you find behavior that diverges from this document, that is a bug — please open an issue at [github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/issues](https://github.com/akii-technologies-ltd/akii-seo-ai-search-optimizer/issues).

## Changes to this policy

This file is versioned with the plugin. Any change to what is collected, when it is sent, or how to opt out will be:

1. Noted in the [CHANGELOG](./CHANGELOG.md) entry for the release that introduces the change.
2. Mentioned in the GitHub release notes.
3. Surfaced in the SessionEnd CTA the first time a user runs the plugin under the new version (one-time notice).
