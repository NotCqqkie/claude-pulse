#!/bin/bash
set -e
PLIST=~/Library/LaunchAgents/com.claudepulse.plist
SCRIPT="$(cd "$(dirname "$0")" && pwd)/keepalive.sh"
LOGS=$HOME/Library/Logs/claude-pulse

CLAUDE=$(command -v claude) || { echo "✗ Install Claude Code first: https://claude.ai/download"; exit 1; }

read -rp "Minutes between pings? [default: 295] " mins
[[ "$mins" =~ ^[1-9][0-9]*$ ]] || mins=295

mkdir -p "$LOGS"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.claudepulse</string>
  <key>ProgramArguments</key><array><string>$SCRIPT</string></array>
  <key>StartInterval</key><integer>300</integer>
  <key>RunAtLoad</key><true/>
  <key>EnvironmentVariables</key><dict>
    <key>INTERVAL</key><string>$((mins*60))</string>
    <key>CLAUDE_BIN</key><string>$CLAUDE</string>
  </dict>
  <key>StandardOutPath</key><string>$LOGS/out.log</string>
  <key>StandardErrorPath</key><string>$LOGS/err.log</string>
</dict></plist>
EOF

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"
echo "✓ Claude Pulse running — pinging every $mins min. Stop: ./uninstall.sh"
