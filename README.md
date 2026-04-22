# Claude Pulse

Keeps your Claude 5-hour usage window always active by silently pinging on a timer or at specific times. Survives Mac sleep, wake, and reboots.

**Requires:** [Claude Code](https://claude.ai/download), logged in. macOS only.

## Install
```bash
git clone https://github.com/NotCqqkie/claude-pulse
cd claude-pulse
./install.sh
```

You'll be asked:
- **Schedule mode** — interval (every N minutes) or specific times of day
- For specific times: `9,14,19` or `8:30,13,18:45` (24-hour format)

## Stop
```bash
./uninstall.sh
```

## Change schedule
Re-run `./install.sh`.

## Token usage

Each ping uses the absolute minimum: `haiku` model, no tools, no skills, no session save, replaced system prompt. ~10–30 tokens per ping vs thousands with default `claude -p`.

## How it works
A LaunchAgent fires `keepalive.sh` either every 5 min (interval mode) or at chosen times (calendar mode). In interval mode, the script also reads `~/.claude-pulse-last` and skips unless enough wall-clock time has passed — so Mac sleep/wake doesn't shift the schedule.

Logs: `~/Library/Logs/claude-pulse/`
