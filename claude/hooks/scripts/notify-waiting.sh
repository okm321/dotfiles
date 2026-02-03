#!/bin/bash

# ミーティング中かチェック（職場カレンダーに現在進行中のイベントがあるか）
if icalBuddy -ic "職場" -nc eventsNow 2>/dev/null | grep -q .; then
  exit 0
fi

# stdinからJSONを読み取り
INPUT=$(cat)
PROJECT_PATH=$(echo "$INPUT" | jq -r '.cwd // empty')
PROJECT_NAME=$(basename "$PROJECT_PATH")
NOTIFICATION_TYPE=$(echo "$INPUT" | jq -r '.notification_type // "unknown"')
MESSAGE=$(echo "$INPUT" | jq -r '.message // empty')

if [ -z "$PROJECT_NAME" ]; then
  PROJECT_NAME="Unknown"
fi

# 通知タイプに応じてメッセージを設定
case "$NOTIFICATION_TYPE" in
  permission_prompt)
    SUBTITLE="Permission required"
    SAY_MSG="許可が必要です"
    ;;
  idle_prompt)
    SUBTITLE="Waiting for input"
    SAY_MSG="入力待ちです"
    ;;
  auth_success)
    SUBTITLE="Authentication success"
    SAY_MSG="認証成功"
    ;;
  elicitation_dialog)
    SUBTITLE="Input required"
    SAY_MSG="入力が必要です"
    ;;
  *)
    SUBTITLE="Notification"
    SAY_MSG="通知があります"
    ;;
esac

# cwdからtmux session/windowを特定（タブ区切りで確実にパース）
TMUX_SESSION=""
TMUX_WINDOW=""
TMUX_WINDOW_NAME=""

if [ -n "$PROJECT_PATH" ]; then
  while IFS=$'\t' read -r pane_path session window window_name; do
    if [ "$pane_path" = "$PROJECT_PATH" ]; then
      TMUX_SESSION="$session"
      TMUX_WINDOW="$window"
      TMUX_WINDOW_NAME="$window_name"
      break
    fi
  done < <(tmux list-panes -a -F '#{pane_current_path}'$'\t''#{session_name}'$'\t''#{window_index}'$'\t''#{window_name}' 2>/dev/null)
fi

# デバッグログ
echo "[$(date)] CWD=$PROJECT_PATH, SESSION=$TMUX_SESSION, WINDOW=$TMUX_WINDOW, WINDOW_NAME=$TMUX_WINDOW_NAME" >> /tmp/claude-notify-debug.log

SCRIPT_DIR="$HOME/.config/claude/hooks/scripts"

# 通知メッセージを組み立て
if [ -n "$TMUX_SESSION" ]; then
  NOTIFY_MSG="${TMUX_SESSION}:${TMUX_WINDOW_NAME} - ${PROJECT_NAME}"
else
  NOTIFY_MSG="${PROJECT_NAME}"
fi

# terminal-notifier: クリックでGhosttyにフォーカス & tmuxセッション/window移動
terminal-notifier \
  -title "Claude Code" \
  -subtitle "${SUBTITLE}" \
  -message "${NOTIFY_MSG}" \
  -sound "Glass" \
  -group "claude-${TMUX_SESSION:-default}" \
  -execute "bash ${SCRIPT_DIR}/focus-session.sh '${TMUX_SESSION}' '${TMUX_WINDOW}'"

say -v Kyoko "${PROJECT_NAME}、${SAY_MSG}"
