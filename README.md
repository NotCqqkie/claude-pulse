# claude-keepalive

Keeps your Claude 5-hour usage window always active by sending a silent `.` ping on a timer. Works across Mac sleep/wake and reboots using real wall-clock time.

**Requires:** [Claude Code](https://claude.ai/download) installed and logged in.

## Install

```bash
git clone https://github.com/YOUR_USERNAME/claude-keepalive
cd claude-keepalive
./install.sh
```

Prompts once for your preferred interval (default: every 4h 55m).

## Stop

```bash
./uninstall.sh
```

## Change settings

Edit the two config lines at the top of `keepalive.sh`, then re-run `./install.sh`.

## How it works

A macOS LaunchAgent checks every 5 minutes. The script compares the current time against a saved timestamp — if enough real time has elapsed, it fires `claude -p "."`. Mac off for hours? It catches up within 5 minutes of waking.
