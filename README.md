# Claude Code Hear

## Why

macOS Accessibility features like VoiceOver are overkill if you just want to hear Claude Code's responses. This project adds lightweight, on-demand audio feedback using the built-in `say` command. A chime plays when a response is ready, and you use `/hear-*` commands to listen. Works across multiple sessions.

## Requirements

- macOS (uses built-in `say` and `afplay` commands)
- `jq`

## Installation

```bash
git clone <repo-url> ~/Source/claude-code-hear
cd ~/Source/claude-code-hear
./install.sh
```

Then restart Claude Code.

## Usage

| Command | Description |
|---|---|
| `/hear-speak` | Read the last response aloud |
| `/hear-summarize` | Speak a short summary of the last response |
| `/hear-replay N` | Read the response from N turns ago |
| `/hear-read-diff` | Describe recent file changes in plain language |
| `/hear-read-error` | Speak just the error message, skipping noise |

Different chime sounds indicate what happened:
- Glass -- response ready
- Funk -- needs your attention
- Bass -- error occurred

## Configuration

Set these environment variables (via `"env"` in `~/.claude/settings.json`):

| Variable | Default | Description |
|---|---|---|
| `CLAUDE_TTS_VOICE` | `Samantha` | Voice name (`say -v '?'` to list all) |
| `CLAUDE_TTS_RATE` | `200` | Words per minute |
| `CLAUDE_TTS_CHIME` | `/System/Library/Sounds/Glass.aiff` | Success chime sound |
