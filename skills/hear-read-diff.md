---
name: hear-read-diff
description: Describe recent file changes in plain language and speak the description.
allowed-tools: Bash(~/Source/claude-code-hear/say.sh *), Bash(~/Source/claude-code-hear/read-diff.sh)
---

1. Get the recent changes:
   ```bash
   ~/Source/claude-code-hear/read-diff.sh
   ```

2. Write a concise plain-language description of the changes. For example: "Added 3 lines to chime.sh in the sound selection section. Removed the old debug logging block from install.sh. Created a new file replay.sh with 40 lines."

3. Speak the description:
   ```bash
   ~/Source/claude-code-hear/say.sh "YOUR DESCRIPTION"
   ```

Say "Reading changes." before you begin. Say nothing else after speaking.
