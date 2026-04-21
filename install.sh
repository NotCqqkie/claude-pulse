#!/bin/bash
set -e

PLIST=~/Library/LaunchAgents/com.claudekeepalive.plist
REPO="$(cd "$(dirname "$0")" && pwd)"
SCRIPT="$REPO/keepalive.sh"

# ── find claude ──────────────────────────────────────────────────────────────
CLAUDE=$(which claude 2>/dev/null) || {
  echo "✗ 'claude' not found. Install Claude Code first: https://claude.ai/download"
  exit 1
}

# ── optional: custom interval ────────────────────────────────────────────────
read -rp "Minutes between keep-alive pings? [default: 295 (4h 55m)] " mins
INTERVAL=$(( ${mins:-295} * 60 ))

# ── patch keepalive.sh ───────────────────────────────────────────────────────
sed -i '' "s|^INTERVAL=.*|INTERVAL=$INTERVAL|" "$SCRIPT"
sed -i '' "s|^CLAUDE_BIN=.*|CLAUDE_BIN=\"$CLAUDE\"|" "$SCRIPT"
chmod +x "$SCRIPT"

# ── write LaunchAgent ────────────────────────────────────────────────────────
cat > "$PLIST" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key><string>com.claudekeepalive</string>
    <key>ProgramArguments</key>
    <array><string>$SCRIPT</string></array>
    <key>StartInterval</key><integer>300</integer>
    <key>RunAtLoad</key><true/>
</dict>
</plist>
EOF

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"
echo "✓ running — pings Claude every ${mins:-295} min. To stop: ./uninstall.sh"
