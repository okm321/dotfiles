#!/bin/bash
INPUT=$(cat)
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
PROJECT=$(basename "$CWD")
[ -z "$PROJECT" ] && PROJECT="Unknown"

source "$(dirname "$0")/detect-tmux.sh"

BIN="$HOME/.config/claude/hooks/scripts/claude-approve"
[ -S /tmp/claude-approve.sock ] && "$BIN" status "running" "$TMUX_SESSION" "$TMUX_WINDOW" "$PROJECT"
