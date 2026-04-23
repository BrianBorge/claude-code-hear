#!/bin/bash
#
# Print a summary of recent git changes to stdout.
# Outputs both the stat summary and full diff for the AI skill to describe.
#

set -euo pipefail

echo "=== STAGED ==="
git diff --staged --stat 2>/dev/null || true
git diff --staged 2>/dev/null || true

echo "=== UNSTAGED ==="
git diff --stat 2>/dev/null || true
git diff 2>/dev/null || true

echo "=== LAST COMMIT ==="
git log -1 --oneline 2>/dev/null || true
git diff HEAD~1 --stat 2>/dev/null || true
git diff HEAD~1 2>/dev/null || true
