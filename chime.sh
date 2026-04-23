#!/bin/bash
#
# Claude Code response chime
# Plays a notification sound when Claude finishes responding,
# and saves the message text for later playback via speak.sh.
#
# Usage: chime.sh [stop|notification|stop_failure]
#
# Receives JSON on stdin with session_id and last_assistant_message fields.
#

set -euo pipefail

MAX_CHARS="${CLAUDE_TTS_MAX_CHARS:-5000}"
SAVE_DIR="/tmp/claude-tts"

EVENT_TYPE="${1:-stop}"
case "$EVENT_TYPE" in
  stop)          CHIME="${CLAUDE_TTS_CHIME:-/System/Library/Sounds/Glass.aiff}" ;;
  notification)  CHIME="/System/Library/Sounds/Funk.aiff" ;;
  stop_failure)  CHIME="/System/Library/Sounds/Basso.aiff" ;;
  *)             CHIME="/System/Library/Sounds/Glass.aiff" ;;
esac

mkdir -p "$SAVE_DIR"

INPUT=$(cat)

SESSION_ID=$(echo "$INPUT" | /usr/bin/jq -r '.session_id // empty')
MESSAGE=$(echo "$INPUT" | /usr/bin/jq -r '.last_assistant_message // empty')

# Only save messages on stop events with substantive content
if [ "$EVENT_TYPE" = "stop" ] && [ -n "$SESSION_ID" ] && [ -n "$MESSAGE" ] && [ "${#MESSAGE}" -gt 20 ]; then
  SESSION_DIR="$SAVE_DIR/$SESSION_ID"
  mkdir -p "$SESSION_DIR"

  # Truncate very long messages
  if [ "${#MESSAGE}" -gt "$MAX_CHARS" ]; then
    MESSAGE="${MESSAGE:0:$MAX_CHARS}... Message truncated."
  fi

  # Strip markdown formatting for cleaner speech
  MESSAGE=$(echo "$MESSAGE" | sed -E '
    s/```[a-z]*//g;
    s/```//g;
    s/^#{1,6} //g;
    s/\*\*([^*]+)\*\*/\1/g;
    s/\*([^*]+)\*/\1/g;
    s/`([^`]+)`/\1/g;
    s/^\s*[-*+] //g;
    s/\[([^]]+)\]\([^)]+\)/\1/g;
  ')

  # Save to numbered history
  COUNT_FILE="$SESSION_DIR/count"
  CURRENT=$(cat "$COUNT_FILE" 2>/dev/null || echo "0")
  NEXT=$((CURRENT + 1))
  echo "$MESSAGE" > "$SESSION_DIR/$NEXT.txt"
  echo "$MESSAGE" > "$SESSION_DIR/latest.txt"
  echo "$NEXT" > "$COUNT_FILE"
fi

afplay "$CHIME" 2>/dev/null &

exit 0
