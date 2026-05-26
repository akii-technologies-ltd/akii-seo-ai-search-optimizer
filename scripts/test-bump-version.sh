#!/usr/bin/env bash
# Self-test for scripts/bump-version.sh.
# Runs in a tmp clone so the live tree is never mutated.
#
# Covers:
#   - basic X.Y.Z bump rewrites plugin.json + marketplace.json + UA strings
#   - prerelease round-trip leaves no dangling -alpha.1 suffix (regression
#     for the bug fixed in PR #7)
#   - bad input rejected (no arg, non-semver, semver with trailing dot)
#   - version-pin check in validator catches drift introduced manually

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# Copy only the files bump-version touches + validator + manifests.
# Avoid copying the .git directory (slow + irrelevant).
mkdir -p "$TMP/.claude-plugin" "$TMP/scripts" "$TMP/skills" "$TMP/commands" "$TMP/agents" "$TMP/hooks"
cp -R "$ROOT/.claude-plugin/." "$TMP/.claude-plugin/"
cp -R "$ROOT/scripts/." "$TMP/scripts/"
cp -R "$ROOT/skills/." "$TMP/skills/"
cp -R "$ROOT/commands/." "$TMP/commands/"
cp -R "$ROOT/agents/." "$TMP/agents/"
cp -R "$ROOT/hooks/." "$TMP/hooks/"
cp "$ROOT/README.md" "$TMP/README.md"
cp "$ROOT/CHANGELOG.md" "$TMP/CHANGELOG.md"

cd "$TMP"

pass() { printf "  \033[32m✓\033[0m %s\n" "$1"; }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAILED=$((FAILED+1)); }
sect() { printf "\n\033[1m▶ %s\033[0m\n" "$1"; }
FAILED=0

extract_version() {
  grep -o '"version": *"[^"]*"' "$1" | head -1 | sed -E 's/.*"([^"]+)"$/\1/'
}

ua_strings() {
  grep -RhoE 'akii-plugin/[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.-]+)?' skills/ commands/ | sort -u
}

sect "1. Bump to a basic X.Y.Z"
./scripts/bump-version.sh 9.9.9 >/dev/null
PV=$(extract_version .claude-plugin/plugin.json)
MV=$(extract_version .claude-plugin/marketplace.json)
[[ "$PV" == "9.9.9" ]] && pass "plugin.json → 9.9.9" || fail "plugin.json is $PV, expected 9.9.9"
[[ "$MV" == "9.9.9" ]] && pass "marketplace.json → 9.9.9" || fail "marketplace.json is $MV, expected 9.9.9"
UAS=$(ua_strings)
[[ "$UAS" == "akii-plugin/9.9.9" ]] && pass "all UA strings → akii-plugin/9.9.9" || fail "UA strings: $UAS"

sect "2. Prerelease round-trip leaves no dangling suffix"
./scripts/bump-version.sh 2.0.0-alpha.1 >/dev/null
UAS=$(ua_strings)
[[ "$UAS" == "akii-plugin/2.0.0-alpha.1" ]] && pass "bump → 2.0.0-alpha.1 clean" || fail "UA strings: $UAS"

./scripts/bump-version.sh 2.2.1 >/dev/null
UAS=$(ua_strings)
[[ "$UAS" == "akii-plugin/2.2.1" ]] && pass "bump back to 2.2.1 — no dangling -alpha.1" || fail "UA strings (regression of PR #7): $UAS"

sect "3. Rejects invalid input"
if ./scripts/bump-version.sh 2>/dev/null; then
  fail "accepted missing arg"
else
  pass "rejects missing arg"
fi
if ./scripts/bump-version.sh v2.0.0 2>/dev/null; then
  fail "accepted leading-v semver"
else
  pass "rejects leading-v semver"
fi
if ./scripts/bump-version.sh 2.0 2>/dev/null; then
  fail "accepted incomplete semver"
else
  pass "rejects incomplete semver"
fi
if ./scripts/bump-version.sh 2.0.0. 2>/dev/null; then
  fail "accepted trailing-dot semver"
else
  pass "rejects trailing-dot semver"
fi

sect "4. Validator §12 catches manual UA drift"
# Restore to a known-good state, then manually corrupt one UA and verify validator §12 catches it.
./scripts/bump-version.sh 2.2.1 >/dev/null
# Corrupt one UA in-place using portable sed.
if [[ "$(uname)" == "Darwin" ]]; then
  sed -i '' -E 's|akii-plugin/2\.2\.1|akii-plugin/0.0.0-drift|' skills/ai-visibility/SKILL.md
else
  sed -i -E 's|akii-plugin/2\.2\.1|akii-plugin/0.0.0-drift|' skills/ai-visibility/SKILL.md
fi
# Validator should now fail on §12. Capture output separately so pipefail
# from validate.sh's intentional exit-1 doesn't kill our pipeline.
VOUT=$(bash scripts/validate.sh 2>&1 || true)
if echo "$VOUT" | grep -q "stale User-Agent: akii-plugin/0.0.0-drift"; then
  pass "validator §12 flags drift"
else
  fail "validator §12 did NOT flag drift (regression of the v2.2.0+ UA pin check)"
fi

echo
if [[ $FAILED -gt 0 ]]; then
  printf "\033[31m%d test(s) failed\033[0m\n" "$FAILED"
  exit 1
fi
printf "\033[32mAll bump-version self-tests passed.\033[0m\n"
