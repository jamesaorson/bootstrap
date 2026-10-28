#!/usr/bin/env bash
# Grok status line, single-line display with color-coded thresholds.
# Schema: Grok status line JSON. The live window is context_window.context_tokens, not session totals.
input=$(cat)

eval "$(echo "$input" | jq -r '
  @sh "ctx_in=\(.context_window.context_tokens // 0)",
  @sh "ctx_size=\(.context_window.context_window_size // 0)",
  @sh "used_pct=\(.context_window.used_percentage // 0)",
  @sh "model_name=\(.model.display_name // "unknown")",
  @sh "cost_usd=\(.cost.total_cost_usd // 0)",
  @sh "duration_ms=\(.cost.total_duration_ms // 0)",
  @sh "cwd=\(.workspace.current_dir // .cwd // "")",
  @sh "git_branch=\(.workspace.branch // "")",
  @sh "worktree=\(.workspace.git_worktree // "")"
' 2>/dev/null)"

# Prefer the branch Grok already resolved; fall back to git, then the worktree name.
if [ -z "$git_branch" ] && [ -n "$cwd" ]; then
  git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
fi
[ -z "$git_branch" ] && git_branch="$worktree"

fmt_tokens() {
  python3 -c "
n = $1
if n >= 1_000_000: print(f'{n/1_000_000:.1f}M')
elif n >= 1_000:   print(f'{n/1_000:.1f}k')
else:              print(n)
"
}

ctx_in_fmt=$(fmt_tokens "$ctx_in")
if [ "${ctx_size:-0}" -gt 0 ]; then
  ctx_size_fmt=$(fmt_tokens "$ctx_size")
else
  ctx_size_fmt="?"
fi

cost_fmt=$(python3 -c "
c = $cost_usd
if c < 0.01:  print(f'\${c:.4f}')
elif c < 1:   print(f'\${c:.3f}')
else:         print(f'\${c:.2f}')
")

# Month-to-date cost: read cached value, refresh inline when stale (>5min) or missing.
# Grok kills processes the statusline leaves in the background, so this stays synchronous.
# ccusage grok monthly is a local log scan and finishes well under the 10s hook timeout.
month_cache="$HOME/.grok/cache/cost-month.txt"
month_cost=""
if [ -f "$month_cache" ]; then
  month_cost=$(cat "$month_cache" 2>/dev/null)
fi
needs_refresh=1
if [ -f "$month_cache" ]; then
  if mtime=$(stat -f %m "$month_cache" 2>/dev/null); then
    :
  else
    mtime=$(stat -c %Y "$month_cache" 2>/dev/null || echo 0)
  fi
  age=$(( $(date +%s) - mtime ))
  [ "$age" -lt 300 ] && needs_refresh=0
fi
if [ "$needs_refresh" = "1" ]; then
  "$HOME/.grok/bin/cost-refresh.sh" >/dev/null 2>&1 || true
  if [ -f "$month_cache" ]; then
    month_cost=$(cat "$month_cache" 2>/dev/null)
  fi
fi
month_label=$(date +%b)

ctx_pct=$(python3 -c "print(int(round(float(${used_pct:-0} or 0))))")

dur_fmt=$(python3 -c "
s = $duration_ms // 1000
m, s = s // 60, s % 60
print(f'{m}m{s:02d}s' if m else f'{s}s')
")

DIM='\033[2m'; CYAN='\033[36m'; GREEN='\033[32m'
YELLOW='\033[33m'; MAGENTA='\033[35m'; BLUE='\033[34m'
RED='\033[31m'; RESET='\033[0m'
SEP="${DIM} | ${RESET}"

# Cost: green <$0.50, yellow <$2, red >=$2
cost_tier=$(python3 -c "
c = $cost_usd
print('RED' if c >= 2.0 else 'YELLOW' if c >= 0.5 else 'GREEN')
")
case "$cost_tier" in
  RED) COST_COLOR="$RED";;
  YELLOW) COST_COLOR="$YELLOW";;
  *) COST_COLOR="$GREEN";;
esac

# Context: blue <50%, yellow 50-79%, red >=80%
if   [ "$ctx_pct" -ge 80 ]; then CTX_COLOR="$RED"
elif [ "$ctx_pct" -ge 50 ]; then CTX_COLOR="$YELLOW"
else                             CTX_COLOR="$BLUE"
fi

printf "  "
if [ -n "$cwd" ]; then
  dir_display=$(basename "$cwd")
  printf "${YELLOW}📁 %s${RESET}%b" "$dir_display" "$SEP"
fi
[ -n "$git_branch" ] && printf "${CYAN}⎇ %s${RESET}%b" "$git_branch" "$SEP"
printf "${MAGENTA}🤖 %s${RESET}%b" "$model_name" "$SEP"
printf "${CTX_COLOR}📊 Ctx: %s/%s (%s%%)${RESET}%b" "$ctx_in_fmt" "$ctx_size_fmt" "$ctx_pct" "$SEP"
printf "${COST_COLOR}💰 %s${RESET}%b" "$cost_fmt" "$SEP"
if [ -n "$month_cost" ]; then
  printf "${YELLOW}📅 %s: \$%s${RESET}%b" "$month_label" "$month_cost" "$SEP"
fi
printf "${DIM}⏱ %s${RESET}\n" "$dur_fmt"
