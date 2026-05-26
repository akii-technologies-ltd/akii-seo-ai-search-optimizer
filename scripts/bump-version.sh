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

sed_i -E "s/(\"version\": *\")[^\"]+(\")/\\1${NEW}\\2/" "$PLUGIN_JSON"
sed_i -E "s/(\"version\": *\")[^\"]+(\")/\\1${NEW}\\2/" "$MARKETPLACE_JSON"

echo "bumped $OLD_PLUGIN → $NEW"
echo "  $PLUGIN_JSON"
echo "  $MARKETPLACE_JSON"
echo ""
echo "next:"
echo "  1. add a CHANGELOG entry for v${NEW}"
echo "  2. ./scripts/validate.sh"
echo "  3. git add .claude-plugin/ CHANGELOG.md && git commit -m \"chore: bump to v${NEW}\""
echo "  4. git tag v${NEW} && git push --tags"
echo "  5. gh release create v${NEW} --target main --title \"v${NEW}\" --notes-from-tag"
