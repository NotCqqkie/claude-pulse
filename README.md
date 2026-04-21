# Claude Pulse 🫀

Keeps your Claude 5-hour usage window always active by silently pinging `claude -p "."` on a timer. Survives Mac sleep, wake, and reboots.

**Requires:** [Claude Code](https://claude.ai/download), logged in. macOS only.

## Install
```bash
git clone https://github.com/NotCqqkie/claude-pulse
cd claude-pulse
./install.sh
```

## Stop
```bash
./uninstall.sh
```

## Change interval
Re-run `./install.sh`.

## How it works
A LaunchAgent wakes every 5 min and runs `keepalive.sh`. The script reads `~/.claude-pulse-last`, skips if not enough wall-clock time has passed, otherwise calls `claude -p "."` and updates the timestamp on success.

Logs: `~/Library/Logs/claude-pulse/`
