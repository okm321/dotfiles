#!/bin/bash
# プロセスツリーを辿ってtmux session/windowを検出
# source して使う。TMUX_SESSION, TMUX_WINDOW が設定される。
# 呼び出し元で CWD を設定しておくとフォールバックに使用される。

TMUX_SESSION=""
TMUX_WINDOW=""

_PANES=$(tmux list-panes -a -F '#{pane_pid}|#{session_name}|#{window_name}' 2>/dev/null)
if [ -z "$_PANES" ]; then return 0 2>/dev/null || true; fi

# Method 1: プロセスツリーを辿る
_PID=$$
while [ -n "$_PID" ] && [ "$_PID" != "1" ] && [ "$_PID" != "0" ]; do
  _MATCH=$(echo "$_PANES" | awk -F'|' -v p="$_PID" '$1==p{print $2"|"$3;exit}')
  if [ -n "$_MATCH" ]; then
    TMUX_SESSION="${_MATCH%%|*}"
    TMUX_WINDOW="${_MATCH#*|}"
    break
  fi
  _PID=$(ps -o ppid= -p "$_PID" 2>/dev/null | tr -d ' ')
done

# Fallback: CWDマッチ（プロセスツリーで見つからない場合）
if [ -z "$TMUX_SESSION" ] && [ -n "$CWD" ]; then
  _TMUX_INFO=$(tmux list-panes -a -F '#{pane_current_path}|#{session_name}|#{window_name}' 2>/dev/null | awk -F'|' -v cwd="$CWD" 'index(cwd, $1) == 1 { print $2 "|" $3; exit }')
  TMUX_SESSION="${_TMUX_INFO%%|*}"
  TMUX_WINDOW="${_TMUX_INFO#*|}"
fi

# 先頭・末尾の空白を除去
TMUX_SESSION=$(echo "$TMUX_SESSION" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
TMUX_WINDOW=$(echo "$TMUX_WINDOW" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
