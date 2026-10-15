#!/usr/bin/env bash
# Exercise the real SessionEnd hook without network access or user cache writes.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEST_DIR="$(mktemp -d "$ROOT/.cta-test.XXXXXX")"
trap 'rm -rf "$TEST_DIR"' EXIT
mkdir -p "$TEST_DIR/bin" "$TEST_DIR/cache/akii-plugin"
cat > "$TEST_DIR/bin/curl" <<'STUB'
#!/usr/bin/env bash
: > "$AKII_CTA_TEST_NETWORK_MARKER"
exit 99
STUB
chmod +x "$TEST_DIR/bin/curl"
export PATH="$TEST_DIR/bin:$PATH"
export CLAUDE_PLUGIN_ROOT="$ROOT"
export XDG_CACHE_HOME="$TEST_DIR/cache"
export AKII_CTA_TEST_NETWORK_MARKER="$TEST_DIR/network-attempt"
export AKII_PLUGIN_DISABLE_TELEMETRY=1
export AKII_PLUGIN_DISABLE_VERSION_CHECK=1
export AKII_PLUGIN_DISABLE_CTA=0

output="$(bash "$ROOT/scripts/akii-cta.sh")"
jq -e '.decision == "approve" and (.systemMessage | contains("Free SEO & AI Search Optimizer by Akii") and contains("Explore Akii Technologies and the products we build") and contains("https://akii.com/?utm_source=plugin&utm_medium=session_end_hook&utm_campaign=akii_plugin_v1") and contains("AKII_PLUGIN_DISABLE_CTA=1") and contains("AKII_PLUGIN_DISABLE_TELEMETRY=1") and (test("Upgrade for|continuous AI visibility monitoring|pro-tier|hosted score"; "i") | not))' <<< "$output" >/dev/null
printf 'PASS: corporate notice, tracked link and opt-outs\n'

output="$(AKII_PLUGIN_DISABLE_CTA=1 bash "$ROOT/scripts/akii-cta.sh")"
jq -e '. == {"decision":"approve"}' <<< "$output" >/dev/null
printf 'PASS: full hook opt-out returns bare approval\n'

installed="$(jq -r .version "$ROOT/.claude-plugin/plugin.json")"
printf '%s' '99.0.0' > "$TEST_DIR/cache/akii-plugin/version-check"
output="$(AKII_PLUGIN_DISABLE_VERSION_CHECK=0 bash "$ROOT/scripts/akii-cta.sh")"
jq -e --arg installed "$installed" '.decision == "approve" and (.systemMessage | contains("v" + $installed + " installed") and contains("v99.0.0 released") and contains("/plugin marketplace update akii") and contains("/reload-plugins"))' <<< "$output" >/dev/null
printf 'PASS: cached update nudge and native update commands\n'

output="$(bash "$ROOT/scripts/akii-cta.sh")"
jq -e '.decision == "approve" and (.systemMessage | contains("Update available") | not)' <<< "$output" >/dev/null
[[ ! -e "$AKII_CTA_TEST_NETWORK_MARKER" ]]
printf 'PASS: version opt-out and zero network attempts\n'
