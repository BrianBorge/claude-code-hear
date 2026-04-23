---
name: hear-replay
description: Speak a response from N turns ago. Usage: /hear-replay 3
disable-model-invocation: true
allowed-tools: Bash(~/Source/claude-code-hear/replay.sh*)
argument-hint: "[turns_back]"
---

Run this command, substituting the user's number argument (default 1 if none given):

```bash
~/Source/claude-code-hear/replay.sh TURNS_BACK
```

Say "Replaying." and nothing else.
