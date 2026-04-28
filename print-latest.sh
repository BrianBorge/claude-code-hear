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

# Find the most recently modified session directory in the save dir
LATEST_DIR=$(ls -td "$SAVE_DIR"/*/ 2>/dev/null | head -1)
SESSION_ID=""
if [ -n "$LATEST_DIR" ]; then
  SESSION_ID=$(basename "$LATEST_DIR")
fi

FILE="$SAVE_DIR/$SESSION_ID/latest.txt"

if [ -z "$SESSION_ID" ] || [ ! -f "$FILE" ]; then
  echo "No saved response found." >&2
  exit 1
fi

cat "$FILE"
