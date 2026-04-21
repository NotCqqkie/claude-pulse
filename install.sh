#!/bin/bash
set -e

PLIST=~/Library/LaunchAgents/com.claudepulse.plist
REPO="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$REPO/keepalive.sh"
CFG="$HOME/.claude-pulse.cfg"
LOGS="$HOME/Library/Logs/claude-pulse"

# ── find claude ───────────────────────────────────────────────────────────────
CLAUDE=$(which claude 2>/dev/null) || {
  echo "✗ 'claude' not found. Install Claude Code first: https://claude.ai/download"
  exit 1
}

# ── optional: custom interval ─────────────────────────────────────────────────
read -rp "Minutes between pings? [default: 295 (4h 55m)] " mins
[[ "$mins" =~ ^[0-9]+$ ]] || mins=295
INTERVAL=$(( mins * 60 ))

# ── write config (separate from repo — git pull will never conflict) ──────────
mkdir -p "$LOGS"
cat > "$CFG" << EOF
INTERVAL=$INTERVAL
CLAUDE_BIN="$CLAUDE"
EOF

chmod +x "$SCRIPT"

# ── write LaunchAgent ─────────────────────────────────────────────────────────
cat > "$PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.claudepulse</string>
    <key>ProgramArguments</key>
    <array><string>$SCRIPT</string></array>
    <key>StartInterval</key><integer>300</integer>
    <key>RunAtLoad</key><true/>
    <key>StandardOutPath</key><string>$LOGS/out.log</string>
    <key>StandardErrorPath</key><string>$LOGS/err.log</string>
</dict>
</plist>
EOF

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"
echo "✓ Claude Pulse running — pinging every $mins min. Stop: ./uninstall.sh"
