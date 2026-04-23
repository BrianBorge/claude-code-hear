---
name: hear-summarize
description: Speak a short plain-language summary of the last response.
allowed-tools: Bash(~/Source/claude-code-hear/say.sh *), Bash(~/Source/claude-code-hear/print-latest.sh)
---

1. Get the last response for this session:
   ```bash
   ~/Source/claude-code-hear/print-latest.sh
   ```

2. Write a 1-2 sentence plain-language summary. Focus on what was done or decided. If the response was mostly code or diffs, describe what changed at a high level.

3. Speak the summary:
   ```bash
   ~/Source/claude-code-hear/say.sh "YOUR SUMMARY"
   ```

Say "Summarizing." before you begin. Say nothing else after speaking.
