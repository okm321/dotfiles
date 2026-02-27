#!/bin/bash
# PermissionRequest フック
# - Edit/Write/NotebookEditは自動承認
# - 安全なBashコマンドは自動承認
# - デーモン未起動時は自動承認（ブロックしない）
# - それ以外はclaude-approveに問い合わせ
# - 全承認時にバックグラウンドで「running」ステータスを送信

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPROVE_BIN="$SCRIPT_DIR/claude-approve"
INPUT=$(cat)

TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')
PROJECT=$(basename "$CWD")

source "$(dirname "$0")/detect-tmux.sh"

notify_running() {
  if [ -S /tmp/claude-approve.sock ] && [ -n "$CWD" ]; then
    ( "$APPROVE_BIN" status "running" "$TMUX_SESSION" "$TMUX_WINDOW" "$PROJECT" ) &
  fi
}

allow() {
  notify_running
  echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
  exit 0
}

deny() {
  echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"deny"}}}'
  exit 0
}

# Edit/Writeは自動承認
if [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "NotebookEdit" ]; then
  allow
fi

# Bash以外はClaude Codeのデフォルト処理に委譲
# Notificationフックが正しいステータスを送るので、ここではrunningを送らない
if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')
DESCRIPTION=$(echo "$INPUT" | jq -r '.tool_input.description // empty')

# 安全なコマンドは自動承認
if echo "$COMMAND" | grep -qE '^(git |gh |npm |pnpm |yarn |bun |go |cargo |make |ls |cat |head |tail |wc |sort |uniq |diff |find |grep |rg |which |pwd|echo |printf |mkdir |cp |mv |chmod |touch |date |env |export |source |test |true|false|\[)'; then
  allow
fi

# デーモンが起動していなければ自動承認（ブロックしない）
if [ ! -S /tmp/claude-approve.sock ]; then
  allow
fi

# PIDファイルがあってもプロセスが死んでいたら掃除して自動承認
if [ -f /tmp/claude-approve.pid ]; then
  DAEMON_PID=$(cat /tmp/claude-approve.pid 2>/dev/null)
  if [ -n "$DAEMON_PID" ] && ! kill -0 "$DAEMON_PID" 2>/dev/null; then
    rm -f /tmp/claude-approve.sock /tmp/claude-approve.pid
    allow
  fi
fi

# デーモンにリクエスト送信
if "$APPROVE_BIN" request "$TOOL_NAME" "$DESCRIPTION" "$COMMAND" "$TMUX_SESSION" "$TMUX_WINDOW" "$PROJECT"; then
  allow
else
  deny
fi
