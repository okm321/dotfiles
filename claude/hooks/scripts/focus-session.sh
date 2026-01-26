#!/bin/bash
# クリック時にGhosttyをアクティブにして、指定されたtmuxセッション/windowに移動

# PATHを明示的に設定（-executeはPATHが最小限）
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

SESSION_NAME="$1"
WINDOW_INDEX="$2"

# Ghosttyをアクティブに
osascript -e 'tell application "Ghostty" to activate'

# tmuxセッション/windowに切り替え
if [ -n "$SESSION_NAME" ]; then
  for CLIENT in $(tmux list-clients -F '#{client_tty}' 2>/dev/null); do
    tmux switch-client -c "$CLIENT" -t "$SESSION_NAME" 2>/dev/null
  done
  if [ -n "$WINDOW_INDEX" ]; then
    tmux select-window -t "${SESSION_NAME}:${WINDOW_INDEX}" 2>/dev/null
  fi
fi
