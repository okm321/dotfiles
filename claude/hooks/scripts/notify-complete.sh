#!/bin/bash

# stdinからJSONを読み取り、プロジェクト名を取得
INPUT=$(cat)
PROJECT_PATH=$(echo "$INPUT" | jq -r '.cwd // empty')
PROJECT_NAME=$(basename "$PROJECT_PATH")

if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME="Unknown"
fi

# 現在のtmuxセッション名、window、pane情報を取得
TMUX_SESSION=""
TMUX_WINDOW=""
TMUX_WINDOW_NAME=""
TMUX_PANE=""
if [ -n "$TMUX" ]; then
  TMUX_SESSION=$(tmux display-message -p '#S' 2>/dev/null)
  TMUX_WINDOW=$(tmux display-message -p '#I' 2>/dev/null)
  TMUX_WINDOW_NAME=$(tmux display-message -p '#W' 2>/dev/null)
  TMUX_PANE=$(tmux display-message -p '#P' 2>/dev/null)
fi

SCRIPT_DIR="$HOME/.config/claude/hooks/scripts"

# 通知メッセージを組み立て
if [ -n "$TMUX_SESSION" ]; then
  NOTIFY_MSG="${TMUX_SESSION}:${TMUX_WINDOW_NAME}.${TMUX_PANE} - ${PROJECT_NAME}"
else
  NOTIFY_MSG="${PROJECT_NAME}"
fi

# terminal-notifier: クリックでGhosttyにフォーカス & tmuxセッション/window/pane移動
terminal-notifier \
  -title "Claude Code" \
  -subtitle "Task completed" \
  -message "${NOTIFY_MSG}" \
  -sound "Glass" \
  -group "claude" \
  -execute "bash ${SCRIPT_DIR}/focus-session.sh '${TMUX_SESSION}' '${TMUX_WINDOW}' '${TMUX_PANE}'"

say -v Kyoko "${PROJECT_NAME}、タスク完了"
