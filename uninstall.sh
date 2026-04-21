#!/bin/bash
PLIST=~/Library/LaunchAgents/com.claudekeepalive.plist
launchctl unload "$PLIST" 2>/dev/null && rm -f "$PLIST" && rm -f ~/.claude-keepalive-last
echo "✓ stopped and removed"
