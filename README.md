# Claude Pulse 🫀

Keeps your Claude 5-hour usage window always active by sending a silent `.` ping on a timer.

Works correctly across Mac sleep, wake, and reboots — uses real wall-clock time, not just "was the Mac on?".

**Requires:** [Claude Code](https://claude.ai/download) installed and logged in.

---

## Install

```bash
git clone https://github.com/NotCqqkie/claude-pulse
cd claude-pulse
./install.sh
```

Prompts once for your ping interval (default: every 4h 55m). That's it.

## Stop

```bash
./uninstall.sh
```

## Change settings

Re-run `./install.sh` — it'll prompt again and overwrite the config.

## How it works

A macOS LaunchAgent wakes every 5 minutes and runs `keepalive.sh`. The script reads a saved timestamp from `~/.claude-pulse-last` and skips unless enough real time has passed. When it fires, it runs `claude -p "."` and only updates the timestamp if the call succeeds.

Mac off for 8 hours? On wake it catches up within 5 minutes.

Logs: `~/Library/Logs/claude-pulse/`
