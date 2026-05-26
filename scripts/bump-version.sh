#!/usr/bin/env bash
# Bump plugin.json + marketplace.json version strings in lockstep.
# Usage: ./scripts/bump-version.sh 2.2.0

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <new-version>" >&2
  echo "  e.g. $0 2.2.0" >&2
  exit 1
fi

NEW="$1"

if ! [[ "$NEW" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.-]+)?$ ]]; then
  echo "error: '$NEW' is not a valid semver (X.Y.Z or X.Y.Z-prerelease)" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN_JSON="$ROOT/.claude-plugin/plugin.json"
MARKETPLACE_JSON="$ROOT/.claude-plugin/marketplace.json"

if [[ ! -f "$PLUGIN_JSON" || ! -f "$MARKETPLACE_JSON" ]]; then
  echo "error: cannot find manifest files under $ROOT/.claude-plugin/" >&2
  exit 1
fi

OLD_PLUGIN=$(grep -o '"version": *"[^"]*"' "$PLUGIN_JSON" | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
OLD_MARKETPLACE=$(grep -o '"version": *"[^"]*"' "$MARKETPLACE_JSON" | head -1 | sed -E 's/.*"([^"]+)"$/\1/')

if [[ "$OLD_PLUGIN" != "$OLD_MARKETPLACE" ]]; then
  echo "warning: manifests already disagree ($OLD_PLUGIN vs $OLD_MARKETPLACE) — bumping both to $NEW anyway" >&2
fi

# Portable sed -i for both BSD (macOS) and GNU.
sed_i() {
  if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# Prefer jq when available — manifests are JSON, regex on JSON is fragile.
if command -v jq >/dev/null 2>&1; then
  tmp="$(mktemp)"
  jq --arg v "$NEW" '.version = $v' "$PLUGIN_JSON" > "$tmp" && mv "$tmp" "$PLUGIN_JSON"
  jq --arg v "$NEW" '.plugins[0].version = $v' "$MARKETPLACE_JSON" > "$tmp" && mv "$tmp" "$MARKETPLACE_JSON"
else
  sed_i -E "s/(\"version\": *\")[^\"]+(\")/\\1${NEW}\\2/" "$PLUGIN_JSON"
  sed_i -E "s/(\"version\": *\")[^\"]+(\")/\\1${NEW}\\2/" "$MARKETPLACE_JSON"
fi

# Rewrite stale akii-plugin/<version> UA strings across skills + commands.
# Catches the recurring drift where a skill body keeps an old version after a release.
# Line-iteration is safe here because plugin file paths don't contain newlines;
# `"$f"` quoting handles spaces (e.g. "AI Search Optimizer/" in user clones).
UA_FILE_COUNT=0
# Important: the version match must consume any trailing -prerelease suffix
# so we don't leave a dangling "-alpha.1" when going from 2.0.0-alpha.1 → 2.2.1.
while IFS= read -r f; do
  [[ -z "$f" ]] && continue
  sed_i -E "s|akii-plugin/[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.-]+)?|akii-plugin/${NEW}|g" "$f"
  UA_FILE_COUNT=$((UA_FILE_COUNT + 1))
done < <(grep -RlE 'akii-plugin/[0-9]+\.[0-9]+\.[0-9]+' "$ROOT/skills" "$ROOT/commands" 2>/dev/null || true)

echo "bumped $OLD_PLUGIN → $NEW"
echo "  $PLUGIN_JSON"
echo "  $MARKETPLACE_JSON"
if [[ $UA_FILE_COUNT -gt 0 ]]; then
  echo "  + User-Agent strings rewritten in $UA_FILE_COUNT file(s) under skills/ + commands/"
fi
echo ""
echo "next:"
echo "  1. add a CHANGELOG entry for v${NEW}"
echo "  2. ./scripts/validate.sh"
echo "  3. git add .claude-plugin/ CHANGELOG.md && git commit -m \"chore: bump to v${NEW}\""
echo "  4. git tag v${NEW} && git push --tags"
echo "  5. gh release create v${NEW} --target main --title \"v${NEW}\" --notes-from-tag"
