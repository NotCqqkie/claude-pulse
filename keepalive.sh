#!/bin/zsh
CFG="$HOME/.claude-pulse.cfg"
[[ -f "$CFG" ]] && source "$CFG" || { echo "claude-pulse: run install.sh first" >&2; exit 1; }

STATE="$HOME/.claude-pulse-last"
NOW=$(date +%s)
LAST=$(cat "$STATE" 2>/dev/null)
[[ "$LAST" =~ ^[0-9]+$ ]] || LAST=0

(( NOW - LAST < INTERVAL )) && exit 0

"$CLAUDE_BIN" -p "." >/dev/null 2>&1 && echo "$NOW" > "$STATE"
