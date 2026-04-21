#!/bin/zsh
# ── config ──────────────────────────────────────────────────────────────────
INTERVAL=17700
CLAUDE_BIN="/Users/lukefinigan/.local/bin/claude"
# ────────────────────────────────────────────────────────────────────────────

STATE="$HOME/.claude-keepalive-last"
NOW=$(date +%s)
LAST=$([[ -f "$STATE" ]] && cat "$STATE" || echo 0)

(( NOW - LAST < INTERVAL )) && exit 0

"$CLAUDE_BIN" -p "." >/dev/null 2>&1
echo "$NOW" > "$STATE"
