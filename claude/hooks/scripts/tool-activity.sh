#!/bin/bash
# PreToolUse: ツール実行時にセッションを「実行中」に更新
[ ! -S /tmp/claude-approve.sock ] && exit 0
INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty' 2>/dev/null)
[ -z "$CWD" ] && exit 0
PROJECT=$(basename "$CWD")
source "$(dirname "$0")/detect-tmux.sh"
"$HOME/.config/claude/hooks/scripts/claude-approve" status "running" "$TMUX_SESSION" "$TMUX_WINDOW" "$PROJECT" &
