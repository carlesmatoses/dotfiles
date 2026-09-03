#!/bin/bash
# Status line derived from PS1='[\u@\h \W]\$ ' found in ~/.bashrc
# Extended with model name, context window usage, and remaining session/week rate limits.
input=$(cat)

dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
host=$(hostname -s)
base=$(basename "$dir")

model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
session_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

out="[$host $base]"

[ -n "$model" ] && out="$out|$model"
[ -n "$used_pct" ] && out="$out|ctx $(printf '%.0f' "$used_pct")%"
[ -n "$session_used" ] && out="$out|ss $(printf '%.0f' "$session_used")%"
[ -n "$week_used" ] && out="$out|wk $(printf '%.0f' "$week_used")%"

printf '%s' "$out"
