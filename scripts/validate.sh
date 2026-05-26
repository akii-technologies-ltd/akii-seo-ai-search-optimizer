#!/usr/bin/env bash
# Pre-submission validator for the Akii — SEO & AI Search Optimizer plugin.
# This is a free, no-login plugin. The validator enforces that posture.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ok()   { printf "  \033[32m✓\033[0m %s\n" "$1"; }
fail() { printf "  \033[31m✗\033[0m %s\n" "$1"; FAILED=$((FAILED+1)); }
sect() { printf "\n\033[1m▶ %s\033[0m\n" "$1"; }

FAILED=0

sect "1. plugin.json"
python3 - <<'PY'
import json
m = json.load(open(".claude-plugin/plugin.json"))
for k in ("name", "description", "version", "author"):
    assert k in m, f"missing key: {k}"
assert len(m["description"]) >= 60, "description too short"
print("ok")
PY
ok "plugin.json schema"

sect "2. SKILL.md frontmatter"
shopt -s nullglob
for f in skills/*/SKILL.md; do
  if ! head -20 "$f" | grep -q '^description:'; then fail "$f missing 'description:'"; fi
done
[[ $FAILED -eq 0 ]] && ok "all $(ls skills | wc -l | tr -d ' ') skills have description"

sect "3. Agent frontmatter (canonical: flat agents/<name>.md with name + description)"
AGENT_FAIL=0
for f in agents/*.md; do
  if ! head -20 "$f" | grep -q '^name:'; then fail "$f missing 'name:'"; AGENT_FAIL=1; fi
  if ! head -20 "$f" | grep -q '^description:'; then fail "$f missing 'description:'"; AGENT_FAIL=1; fi
done
if compgen -G "agents/*/AGENT.md" > /dev/null; then
  fail "found legacy agents/<name>/AGENT.md folder layout — flatten to agents/<name>.md"
  AGENT_FAIL=1
fi
[[ $AGENT_FAIL -eq 0 ]] && ok "all $(ls agents/*.md 2>/dev/null | wc -l | tr -d ' ') agents have name + description (flat layout)"

sect "4. Command frontmatter"
CMD_FAIL=0
for f in commands/*.md; do
  if ! head -10 "$f" | grep -q '^description:'; then fail "$f missing 'description:'"; CMD_FAIL=1; fi
  if ! head -10 "$f" | grep -q '^argument-hint:'; then printf "  \033[33m⚠\033[0m %s missing argument-hint (recommended)\n" "$f"; fi
done
[[ $CMD_FAIL -eq 0 ]] && ok "all $(ls commands | wc -l | tr -d ' ') commands have description (canonical Claude Code spec — name = filename)"

sect "5. hooks.json schema"
python3 - <<'PY'
import json
h = json.load(open("hooks/hooks.json"))
assert "hooks" in h
for evt, defs in h["hooks"].items():
    for d in defs:
        assert "hooks" in d
        for inner in d["hooks"]:
            assert inner.get("type") == "command"
            assert "command" in inner
print("ok")
PY
ok "hooks.json valid"

sect "6. No-login posture (free lead funnel)"
NO_LOGIN_FAIL=0
if [[ -f .mcp.json ]]; then fail ".mcp.json present — plugin must not ship MCP that gates skills behind login"; NO_LOGIN_FAIL=1; fi
if [[ -d mcp-server ]]; then fail "mcp-server/ present — should not ship with the lead-funnel plugin"; NO_LOGIN_FAIL=1; fi
HITS="$(grep -RIl --include='*.md' 'requires_mcp: true\|OAuth flow\|login required\|sign in to use' skills agents commands 2>/dev/null || true)"
if [[ -n "$HITS" ]]; then
  fail "skills mention login/MCP-gating — plugin must work standalone"
  echo "$HITS" | sed 's/^/        /'
  NO_LOGIN_FAIL=1
fi
[[ $NO_LOGIN_FAIL -eq 0 ]] && ok "no login gating — all skills run locally"

sect "7. claude plugin validate (optional)"
if command -v claude >/dev/null 2>&1; then
  if claude plugin validate "$ROOT" 2>&1 | tee /tmp/akii-claude-validate.log >/dev/null; then
    ok "claude plugin validate passed"
  else
    fail "claude plugin validate failed (see /tmp/akii-claude-validate.log)"
  fi
else
  echo "  (claude CLI not on PATH — skipping)"
fi

sect "8. CTA hook executability"
if [[ -x scripts/akii-cta.sh ]]; then
  ok "CTA script executable"
else
  fail "scripts/akii-cta.sh not executable — run chmod +x"
fi

sect "9. Manifest versions in lockstep"
PLUGIN_V=$(grep -o '"version": *"[^"]*"' .claude-plugin/plugin.json | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
MARKET_V=$(grep -o '"version": *"[^"]*"' .claude-plugin/marketplace.json | head -1 | sed -E 's/.*"([^"]+)"$/\1/')
if [[ "$PLUGIN_V" == "$MARKET_V" ]]; then
  ok "plugin.json + marketplace.json both at $PLUGIN_V"
else
  fail "version drift: plugin.json=$PLUGIN_V vs marketplace.json=$MARKET_V — run scripts/bump-version.sh"
fi

sect "10. Cross-references resolve (skill/agent/command slugs)"
XREF_FAIL=0
SKILL_SLUGS=$(ls -d skills/*/ 2>/dev/null | xargs -n1 basename | sort -u)
AGENT_SLUGS=$(ls agents/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//' | sort -u)
CMD_SLUGS=$(ls commands/*.md 2>/dev/null | xargs -n1 basename | sed 's/\.md$//' | sort -u)
ALL_SLUGS=$(printf '%s\n%s\n%s\n' "$SKILL_SLUGS" "$AGENT_SLUGS" "$CMD_SLUGS" | sort -u)

# Find references like /akii-seo-ai-search-optimizer:<slug> and /<slug> (commands)
REFS=$(grep -RhoE '/akii-seo-ai-search-optimizer:[a-z0-9-]+' \
        README.md CHANGELOG.md skills agents commands 2>/dev/null \
        | sed 's|/akii-seo-ai-search-optimizer:||' | sort -u)
for ref in $REFS; do
  if ! echo "$ALL_SLUGS" | grep -qx "$ref"; then
    fail "dangling reference: /akii-seo-ai-search-optimizer:$ref (no skill/agent/command with that slug)"
    XREF_FAIL=1
  fi
done
[[ $XREF_FAIL -eq 0 ]] && ok "all /akii-seo-ai-search-optimizer:<slug> references resolve"

sect "11. README counts match filesystem"
COUNT_FAIL=0
SKILL_COUNT=$(ls -d skills/*/ 2>/dev/null | wc -l | tr -d ' ')
AGENT_COUNT=$(ls agents/*.md 2>/dev/null | wc -l | tr -d ' ')
CMD_COUNT=$(ls commands/*.md 2>/dev/null | wc -l | tr -d ' ')
# Look for explicit count claims like "Skills (13)" / "Agents (5)" / "Commands (8)" in README
if ! grep -qE "^### Skills \(${SKILL_COUNT}\)" README.md; then
  fail "README does not say 'Skills (${SKILL_COUNT})' (filesystem has $SKILL_COUNT)"; COUNT_FAIL=1
fi
if ! grep -qE "^### Agents \(${AGENT_COUNT}\)" README.md; then
  fail "README does not say 'Agents (${AGENT_COUNT})' (filesystem has $AGENT_COUNT)"; COUNT_FAIL=1
fi
if ! grep -qE "^### Commands \(${CMD_COUNT}\)" README.md; then
  fail "README does not say 'Commands (${CMD_COUNT})' (filesystem has $CMD_COUNT)"; COUNT_FAIL=1
fi
[[ $COUNT_FAIL -eq 0 ]] && ok "README counts match filesystem (S=$SKILL_COUNT A=$AGENT_COUNT C=$CMD_COUNT)"

sect "12. Trigger phrase overlap warning"
# Pairwise comparison of skill descriptions — flag pairs sharing 5+ quoted trigger phrases.
python3 - <<'PY'
import glob, re, sys
def triggers(text):
    return set(p.strip().lower() for p in re.findall(r'"([^"]{3,60})"', text))
skills = {}
for f in sorted(glob.glob("skills/*/SKILL.md")):
    head = open(f).read(2000)
    m = re.search(r'^description:\s*(.+?)(?=^---|\n\n)', head, re.M | re.S)
    if m:
        skills[f.split('/')[1]] = triggers(m.group(1))
names = list(skills)
warned = 0
for i, a in enumerate(names):
    for b in names[i+1:]:
        overlap = skills[a] & skills[b]
        if len(overlap) >= 5:
            print(f"  \033[33m⚠\033[0m {a} ↔ {b} share {len(overlap)} trigger phrases")
            warned += 1
if warned == 0:
    print("  \033[32m✓\033[0m no high-overlap skill pairs (threshold: 5+ shared trigger phrases)")
PY

echo
if [[ $FAILED -gt 0 ]]; then
  printf "\033[31m%d check(s) failed\033[0m\n" "$FAILED"
  exit 1
fi
printf "\033[32mAll pre-submission checks passed.\033[0m\n"
