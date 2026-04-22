#!/bin/zsh
: ${INTERVAL:=0} ${CLAUDE_BIN:=claude}
STATE=$HOME/.claude-pulse-last

if (( INTERVAL > 0 )); then
  LAST=$(cat $STATE 2>/dev/null)
  [[ $LAST =~ ^[0-9]+$ ]] || LAST=0
  NOW=$(date +%s)
  (( NOW - LAST < INTERVAL )) && exit
fi

$CLAUDE_BIN -p . --model haiku --tools "" --disable-slash-commands \
  --no-session-persistence --system-prompt . >/dev/null 2>&1 \
  && date +%s > $STATE
