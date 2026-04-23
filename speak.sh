#!/bin/bash
#
# Speak the last saved Claude Code response for the current session.
#
# Usage:
#   speak.sh [session_id]
#
# If no session_id is given, determines the current session by finding
# the most recently modified transcript for the current working directory.
#

set -euo pipefail

VOICE="${CLAUDE_TTS_VOICE:-Samantha}"
RATE="${CLAUDE_TTS_RATE:-200}"
SAVE_DIR="/tmp/claude-tts"

if [ ! -d "$SAVE_DIR" ]; then
  echo "No saved responses found." >&2
  exit 1
fi

SESSION_ID="${1:-}"

if [ -z "$SESSION_ID" ]; then
  # Derive the project directory from CWD (same path sanitization Claude Code uses)
  SANITIZED_CWD=$(echo "$PWD" | sed 's|^/||' | tr '/' '-')
  PROJECT_DIR="$HOME/.claude/projects/-$SANITIZED_CWD"

  if [ -d "$PROJECT_DIR" ]; then
    LATEST_TRANSCRIPT=$(ls -t "$PROJECT_DIR"/*.jsonl 2>/dev/null | head -1)
    if [ -n "$LATEST_TRANSCRIPT" ]; then
      SESSION_ID=$(basename "$LATEST_TRANSCRIPT" .jsonl)
    fi
  fi
fi

FILE="$SAVE_DIR/$SESSION_ID/latest.txt"

if [ -z "$SESSION_ID" ] || [ ! -f "$FILE" ]; then
  echo "No saved response to speak." >&2
  exit 1
fi

# Kill any in-progress speech
killall say 2>/dev/null || true

MESSAGE=$(cat "$FILE")
say -v "$VOICE" -r "$RATE" "$MESSAGE" &

exit 0
