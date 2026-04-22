# Claude Pulse 🫀

Keeps your Claude 5-hour usage window always active. Pings on a timer or at specific times. Survives Mac sleep, wake, reboots.

**Requires:** [Claude Code](https://claude.ai/download), logged in. macOS only.

## Install
```bash
git clone https://github.com/NotCqqkie/claude-pulse && cd claude-pulse && ./install.sh
```

One prompt:
- `295` → every 295 min
- `9,14,19:30` → at 9:00, 14:00, and 19:30 daily

## Stop
```bash
./uninstall.sh
```

## Change schedule
Re-run `./install.sh`.

## Token usage
Each ping uses `haiku`, no tools, no skills, no session save, replaced system prompt — ~10–30 tokens vs thousands with default `claude -p`.

Logs: `~/Library/Logs/claude-pulse/`
