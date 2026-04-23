---
name: hear-read-error
description: Extract and speak just the error message from the last response, skipping noise and stack traces.
allowed-tools: Bash(~/Source/claude-code-hear/say.sh *), Bash(~/Source/claude-code-hear/print-latest.sh)
---

1. Get the last response for this session:
   ```bash
   ~/Source/claude-code-hear/print-latest.sh
   ```

2. Extract the key error message from the text. Skip stack traces, verbose output, and noise. Identify the root cause error line. If there are multiple errors, mention the primary one and note how many others there are.

3. Speak the extracted error:
   ```bash
   ~/Source/claude-code-hear/say.sh "YOUR EXTRACTED ERROR"
   ```

Say "Reading error." before you begin. Say nothing else after speaking.
