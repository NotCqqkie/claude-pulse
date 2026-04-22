#!/bin/bash
set -e
PLIST=~/Library/LaunchAgents/com.claudepulse.plist
SCRIPT="$(cd "$(dirname "$0")" && pwd)/keepalive.sh"
LOGS=$HOME/Library/Logs/claude-pulse

CLAUDE=$(command -v claude) || { echo "✗ Install Claude Code first: https://claude.ai/download"; exit 1; }

echo "Schedule mode:"
echo "  1) Interval — every N minutes (default)"
echo "  2) Specific times — e.g. 9,14,19 or 8:30,13,18:45"
read -rp "Choice [1]: " mode

INTERVAL=0
TRIGGER="<key>StartInterval</key><integer>300</integer>"

if [[ "$mode" == "2" ]]; then
  read -rp "Times (24h, comma-separated): " times
  SLOTS=""
  IFS=',' read -ra parts <<< "$times"
  for p in "${parts[@]}"; do
    p=${p// /}
    h=${p%%:*}; m=${p##*:}; [[ "$m" == "$h" ]] && m=0
    [[ "$h" =~ ^[0-9]+$ ]] && [[ "$m" =~ ^[0-9]+$ ]] && (( h<24 && m<60 )) || {
      echo "✗ invalid time: $p"; exit 1
    }
    SLOTS+="    <dict><key>Hour</key><integer>$h</integer><key>Minute</key><integer>$m</integer></dict>"$'\n'
  done
  TRIGGER="<key>StartCalendarInterval</key><array>"$'\n'"$SLOTS  </array>"
  DESC="at $times"
else
  read -rp "Minutes between pings? [default: 295] " mins
  [[ "$mins" =~ ^[1-9][0-9]*$ ]] || mins=295
  INTERVAL=$(( mins * 60 ))
  DESC="every $mins min"
fi

mkdir -p "$LOGS"
cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>Label</key><string>com.claudepulse</string>
  <key>ProgramArguments</key><array><string>$SCRIPT</string></array>
  $TRIGGER
  <key>RunAtLoad</key><true/>
  <key>EnvironmentVariables</key><dict>
    <key>INTERVAL</key><string>$INTERVAL</string>
    <key>CLAUDE_BIN</key><string>$CLAUDE</string>
  </dict>
  <key>StandardOutPath</key><string>$LOGS/out.log</string>
  <key>StandardErrorPath</key><string>$LOGS/err.log</string>
</dict></plist>
EOF

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"
echo "✓ Claude Pulse running — pinging $DESC. Stop: ./uninstall.sh"
