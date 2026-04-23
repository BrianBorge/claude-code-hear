#!/bin/bash
#
# Speak a Claude Code response from N turns ago.
#
# Usage:
#   replay.sh [turns_back] [session_id]
#
# turns_back defaults to 1 (the previous response).
# 0 is equivalent to speak.sh (the current/latest response).
#

set -euo pipefail

VOICE="${CLAUDE_TTS_VOICE:-Samantha}"
RATE="${CLAUDE_TTS_RATE:-200}"
SAVE_DIR="/tmp/claude-tts"
TURNS_BACK="${1:-1}"
SESSION_ID="${2:-}"

if [ ! -d "$SAVE_DIR" ]; then
  echo "No saved responses found." >&2
  exit 1
fi

if [ -z "$SESSION_ID" ]; then
  SANITIZED_CWD=$(echo "$PWD" | sed 's|^/||' | tr '/' '-')
  PROJECT_DIR="$HOME/.claude/projects/-$SANITIZED_CWD"

  if [ -d "$PROJECT_DIR" ]; then
    LATEST_TRANSCRIPT=$(ls -t "$PROJECT_DIR"/*.jsonl 2>/dev/null | head -1)
    if [ -n "$LATEST_TRANSCRIPT" ]; then
      SESSION_ID=$(basename "$LATEST_TRANSCRIPT" .jsonl)
    fi
  fi
fi

SESSION_DIR="$SAVE_DIR/$SESSION_ID"
COUNT_FILE="$SESSION_DIR/count"

if [ -z "$SESSION_ID" ] || [ ! -f "$COUNT_FILE" ]; then
  echo "No history available." >&2
  exit 1
fi

CURRENT=$(cat "$COUNT_FILE")
TARGET=$((CURRENT - TURNS_BACK))

if [ "$TARGET" -lt 1 ]; then
  echo "Not enough history. Only $CURRENT responses saved." >&2
  exit 1
fi

FILE="$SESSION_DIR/$TARGET.txt"
if [ ! -f "$FILE" ]; then
  echo "Response $TARGET not found." >&2
  exit 1
fi

killall say 2>/dev/null || true

MESSAGE=$(cat "$FILE")
say -v "$VOICE" -r "$RATE" "$MESSAGE" &

exit 0
