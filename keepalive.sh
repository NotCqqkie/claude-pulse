#!/bin/zsh
: ${INTERVAL:=17700} ${CLAUDE_BIN:=claude}
STATE=$HOME/.claude-pulse-last
LAST=$(cat $STATE 2>/dev/null)
[[ $LAST =~ ^[0-9]+$ ]] || LAST=0
NOW=$(date +%s)
(( NOW - LAST < INTERVAL )) && exit
$CLAUDE_BIN -p . >/dev/null 2>&1 && echo $NOW > $STATE
