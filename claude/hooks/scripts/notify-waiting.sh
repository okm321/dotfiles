#!/bin/bash
INPUT=$(cat)

NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // empty')

# idle_prompt は応答完了のたびに発火するので除外（Stopフックのidleでカバー）
# permission_prompt は PermissionRequest フックで処理済みなので除外
# elicitation_dialog のみ「入力待ち」として扱う
case "$NOTIFICATION_TYPE" in
  elicitation_dialog) ;;
  *) exit 0 ;;
esac

CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
MESSAGE=$(echo "$INPUT" | jq -r '.message // empty')
PROJECT=$(basename "$CWD")
[ -z "$PROJECT" ] && PROJECT="Unknown"

source "$(dirname "$0")/detect-tmux.sh"

BIN="$HOME/.config/claude/hooks/scripts/claude-approve"
[ -S /tmp/claude-approve.sock ] && "$BIN" status "waiting" "$TMUX_SESSION" "$TMUX_WINDOW" "$PROJECT" "$MESSAGE"
