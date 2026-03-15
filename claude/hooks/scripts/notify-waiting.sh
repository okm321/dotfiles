#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/tmux-status.sh"

INPUT=$(cat)
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // empty')

case "$NOTIFICATION_TYPE" in
  permission_prompt|elicitation_dialog)
    set_claude_status waiting
    ;;
esac
