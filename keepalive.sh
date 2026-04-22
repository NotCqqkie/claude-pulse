#!/bin/zsh
: ${INTERVAL:=0} ${CLAUDE_BIN:=claude}
S=$HOME/.claude-pulse-last
if (( INTERVAL > 0 )); then
  L=$(cat $S 2>/dev/null); [[ $L =~ ^[0-9]+$ ]] || L=0
  (( $(date +%s) - L < INTERVAL )) && exit
fi
$CLAUDE_BIN -p . --model haiku --tools "" --disable-slash-commands --no-session-persistence --system-prompt . >/dev/null 2>&1 && date +%s > $S
