---
name: hear-read-recap
description: Read aloud only the recap or summary section of the last response, as written, skipping code and intermediate steps.
allowed-tools: Bash(~/Source/claude-code-hear/say.sh *), Bash(~/Source/claude-code-hear/print-latest.sh)
---

1. Get the last response for this session:
   ```bash
   ~/Source/claude-code-hear/print-latest.sh
   ```

2. Find the recap in the response and extract it verbatim. Look for: a trailing wrap-up sentence or two at the end, a "Summary" / "Recap" heading, or a final paragraph that states what changed and what's next. Skip code blocks, tool output, and intermediate narration. Do not rewrite or re-summarize — read what is already there. If no recap is present, say "No recap found." instead.

3. Speak the extracted recap:
   ```bash
   ~/Source/claude-code-hear/say.sh "EXTRACTED RECAP"
   ```

Say "Reading recap." before you begin. Say nothing else after speaking.
