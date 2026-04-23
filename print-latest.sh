#!/bin/bash
#
# Print the last saved Claude Code response for the current session to stdout.
# Used by AI-reasoning skills to reliably get the correct session's text.
#

set -euo pipefail

SAVE_DIR="/tmp/claude-tts"

if [ ! -d "$SAVE_DIR" ]; then
  echo "No saved responses found." >&2
  exit 1
fi

# Derive the project directory from CWD (same path sanitization Claude Code uses)
SANITIZED_CWD=$(echo "$PWD" | sed 's|^/||' | tr '/' '-')
PROJECT_DIR="$HOME/.claude/projects/-$SANITIZED_CWD"

SESSION_ID=""
if [ -d "$PROJECT_DIR" ]; then
  LATEST_TRANSCRIPT=$(ls -t "$PROJECT_DIR"/*.jsonl 2>/dev/null | head -1)
  if [ -n "$LATEST_TRANSCRIPT" ]; then
    SESSION_ID=$(basename "$LATEST_TRANSCRIPT" .jsonl)
  fi
fi

FILE="$SAVE_DIR/$SESSION_ID/latest.txt"

if [ -z "$SESSION_ID" ] || [ ! -f "$FILE" ]; then
  echo "No saved response found." >&2
  exit 1
fi

cat "$FILE"
