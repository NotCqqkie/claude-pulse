#!/bin/bash
PLIST=~/Library/LaunchAgents/com.claudepulse.plist

if [[ ! -f "$PLIST" ]]; then
  echo "claude-pulse is not installed"
  exit 0
fi

launchctl unload "$PLIST" 2>/dev/null || true
rm -f "$PLIST" ~/.claude-pulse-last ~/.claude-pulse.cfg
echo "✓ Claude Pulse stopped and removed"
