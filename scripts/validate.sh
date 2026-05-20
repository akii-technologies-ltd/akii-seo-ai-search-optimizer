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

echo
if [[ $FAILED -gt 0 ]]; then
  printf "\033[31m%d check(s) failed\033[0m\n" "$FAILED"
  exit 1
fi
printf "\033[32mAll pre-submission checks passed.\033[0m\n"
