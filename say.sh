#!/bin/bash
#
# Wrapper around macOS say that applies voice/rate configuration.
#
# Usage: say.sh "text to speak"
#

set -euo pipefail

VOICE="${CLAUDE_TTS_VOICE:-Samantha}"
RATE="${CLAUDE_TTS_RATE:-200}"

killall say 2>/dev/null || true

say -v "$VOICE" -r "$RATE" "$1" &

exit 0
