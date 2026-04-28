#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS="$HOME/.claude/settings.json"
SKILLS_SRC="$SCRIPT_DIR/skills"

echo "Installing Claude Code Hear..."

# Check dependencies
if ! command -v jq &>/dev/null; then
  echo "Error: jq is required. Install with: brew install jq" >&2
  exit 1
fi

# Clean up old installation
rm -rf "$HOME/.claude/skills/speak" 2>/dev/null
if [ -f "$SETTINGS" ] && jq -e '.hooks' "$SETTINGS" &>/dev/null; then
  # Remove any hook entries referencing the old claude-code-tts path
  UPDATED=$(jq '
    .hooks |= with_entries(
      .value |= [.[] | select(
        (.hooks // []) | all(.command // "" | contains("claude-code-tts") | not)
      )]
    ) | .hooks |= with_entries(select(.value | length > 0))
    | if .hooks == {} then del(.hooks) else . end
  ' "$SETTINGS")
  echo "$UPDATED" > "$SETTINGS"
  echo "Cleaned up old installation"
fi

# Install all skills
SKILL_NAMES=("hear-speak" "hear-replay" "hear-summarize" "hear-read-diff" "hear-read-error" "hear-read-recap")

for SKILL in "${SKILL_NAMES[@]}"; do
  DEST="$HOME/.claude/skills/$SKILL"
  mkdir -p "$DEST"
  cp "$SKILLS_SRC/$SKILL.md" "$DEST/SKILL.md"
  sed -i '' "s|~/Source/claude-code-hear|$SCRIPT_DIR|g" "$DEST/SKILL.md"
  echo "Installed /$SKILL"
done

# Add hooks to settings.json
mkdir -p "$HOME/.claude"
if [ ! -f "$SETTINGS" ]; then
  echo '{}' > "$SETTINGS"
fi

add_hook() {
  local EVENT="$1"
  local CMD="$2"

  if jq -e --arg cmd "$CMD" ".hooks.${EVENT}[]?.hooks[]? | select(.command == \$cmd)" "$SETTINGS" &>/dev/null; then
    echo "$EVENT hook already installed, skipping"
  else
    local HOOK_JSON
    HOOK_JSON=$(jq -n --arg cmd "$CMD" '{hooks: [{type: "command", command: $cmd, async: true}]}')
    UPDATED=$(jq --arg event "$EVENT" --argjson hook "$HOOK_JSON" \
      '.hooks[$event] = ((.hooks[$event] // []) + [$hook])' "$SETTINGS")
    echo "$UPDATED" > "$SETTINGS"
    echo "Added $EVENT hook"
  fi
}

add_hook "Stop" "$SCRIPT_DIR/chime.sh stop"
add_hook "Notification" "$SCRIPT_DIR/chime.sh notification"
add_hook "StopFailure" "$SCRIPT_DIR/chime.sh stop_failure"

echo "Done. Restart Claude Code to activate."
