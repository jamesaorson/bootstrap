#!/usr/bin/env bash
# Refresh cached month-to-date Claude Code cost via ccusage.
# Writes a single dollar amount (no $) to ~/.claude/cache/cost-month.txt.
set -u
CACHE_DIR="$HOME/.claude/cache"
OUT="$CACHE_DIR/cost-month.txt"
LOCK="$CACHE_DIR/cost-month.lock"
mkdir -p "$CACHE_DIR"

# Single-flight: skip if another refresh is already running (mkdir is atomic).
if ! mkdir "$LOCK" 2>/dev/null; then
  exit 0
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT

# The statusline runs with a minimal environment, so put node/ccusage on PATH.
for d in "$HOME"/.nvm/versions/node/*/bin /opt/homebrew/bin /usr/local/bin; do
  [ -d "$d" ] && PATH="$d:$PATH"
done
export PATH

month=$(date +%Y-%m)
if command -v ccusage >/dev/null 2>&1; then
  json=$(ccusage claude monthly --json 2>/dev/null) || exit 0
else
  json=$(npx -y ccusage@latest claude monthly --json 2>/dev/null) || exit 0
fi

cost=$(printf '%s' "$json" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
target = '$month'
for row in data.get('monthly', []):
    if row.get('month') == target:
        print(f\"{row.get('totalCost', 0):.2f}\")
        break
")

[ -n "$cost" ] && printf '%s' "$cost" > "$OUT"
