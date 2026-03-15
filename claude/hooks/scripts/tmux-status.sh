#!/bin/bash
# tmux ウィンドウの @claude-status を操作するヘルパー

set_claude_status() {
  local status="$1"
  [ -z "$TMUX_PANE" ] && return 0
  local current
  current=$(tmux show-option -wqv -t "$TMUX_PANE" @claude-status 2>/dev/null)
  [ "$current" = "$status" ] && return 0
  tmux set-option -w -t "$TMUX_PANE" @claude-status "$status" 2>/dev/null
}

clear_claude_status() {
  [ -z "$TMUX_PANE" ] && return 0
  tmux set-option -wu -t "$TMUX_PANE" @claude-status 2>/dev/null
}
