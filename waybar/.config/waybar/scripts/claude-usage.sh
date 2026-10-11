#!/bin/bash

# Live Claude Code usage: cost (ccusage) + real 5h/7d rate-limit % (statusline cache)
CCUSAGE="/home/azeroth/.local/share/fnm/node-versions/v24.14.0/installation/bin/node /home/azeroth/.local/share/fnm/node-versions/v24.14.0/installation/lib/node_modules/ccusage/src/cli.js"
RATE_CACHE="$HOME/.cache/claude-rate-limits.json"

data=$($CCUSAGE blocks --active --json 2>/dev/null)
block=$(echo "$data" | jq -c '.blocks[0] // empty')

# Rate-limit % written by ~/.claude/statusline-command.sh on each prompt.
# Stale (>20min old, no prompt fired recently) is still shown but flagged in tooltip.
five_pct="" week_pct="" rate_age=""
if [ -f "$RATE_CACHE" ]; then
    five_pct=$(jq -r '.five_hour // empty' "$RATE_CACHE" 2>/dev/null)
    week_pct=$(jq -r '.seven_day // empty' "$RATE_CACHE" 2>/dev/null)
    updated=$(jq -r '.updated // empty' "$RATE_CACHE" 2>/dev/null)
    [ -n "$updated" ] && rate_age=$(( $(date +%s) - updated ))
fi

if [ -z "$block" ] && [ -z "$five_pct" ]; then
    echo '{"text":"󰚩 idle","tooltip":"No active Claude session","class":"claude-idle"}'
    exit 0
fi

cost="0" proj_cost="0" burn="0" tokens="0" rem_h="0" rem_m="0"
if [ -n "$block" ]; then
    cost=$(echo "$block" | jq -r '.costUSD')
    proj_cost=$(echo "$block" | jq -r '.projection.totalCost')
    remaining_min=$(echo "$block" | jq -r '.projection.remainingMinutes')
    burn=$(echo "$block" | jq -r '.burnRate.costPerHour')
    tokens=$(echo "$block" | jq -r '.totalTokens')
    rem_h=$((remaining_min / 60))
    rem_m=$((remaining_min % 60))
fi

cost_fmt=$(printf "%.2f" "$cost")
proj_fmt=$(printf "%.2f" "$proj_cost")
burn_fmt=$(printf "%.2f" "$burn")

five_int="" week_int=""
[ -n "$five_pct" ] && five_int=$(printf "%.0f" "$five_pct")
[ -n "$week_pct" ] && week_int=$(printf "%.0f" "$week_pct")

# Severity from the real rate limits when we have them, else fall back to cost.
class=$(awk -v five="${five_int:--1}" -v week="${week_int:--1}" -v cost="$cost" 'BEGIN {
    m = (five > week) ? five : week;
    if (m < 0) m = -1;
    if (m >= 0) {
        if (m >= 90) print "claude-critical";
        else if (m >= 70) print "claude-warning";
        else print "claude-ok";
    } else if (cost > 25) print "claude-critical";
    else if (cost > 15) print "claude-warning";
    else print "claude-ok";
}')

# Bar text: prefer 5h%, fall back to cost-only display.
if [ -n "$five_int" ]; then
    text="󰚩 ${five_int}%"
    [ -n "$week_int" ] && text="${text} 󰃭 ${week_int}%"
else
    text="󰚩 \$${cost_fmt}"
fi

stale_note=""
if [ -n "$rate_age" ] && [ "$rate_age" -gt 1200 ]; then
    stale_note=" (stale, last prompt $((rate_age / 60))m ago)"
fi

tooltip=$(printf '5h limit: %s%%\n7d limit: %s%%%s\nSession cost: $%s (proj $%s)\nBurn rate: $%s/hr\nTokens: %s\nResets in: %sh %sm' \
    "${five_int:-?}" "${week_int:-?}" "$stale_note" "$cost_fmt" "$proj_fmt" "$burn_fmt" "$tokens" "$rem_h" "$rem_m")

jq -nc --arg text "$text" --arg tooltip "$tooltip" --arg class "$class" \
    '{text: $text, tooltip: $tooltip, class: $class}'
