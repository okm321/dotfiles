#!/bin/bash
# PermissionRequest フック
# - Edit/Write/NotebookEditは自動承認
# - 安全なBashコマンドは自動承認
# - それ以外はClaude Codeのデフォルト処理に委譲（ユーザーが選択）

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/tmux-status.sh"

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')

allow() {
  echo '{"hookSpecificOutput":{"hookEventName":"PermissionRequest","decision":{"behavior":"allow"}}}'
  exit 0
}

# Edit/Writeは自動承認
if [ "$TOOL_NAME" = "Edit" ] || [ "$TOOL_NAME" = "Write" ] || [ "$TOOL_NAME" = "NotebookEdit" ]; then
  allow
fi

# Bash以外はClaude Codeのデフォルト処理に委譲
if [ "$TOOL_NAME" != "Bash" ]; then
  exit 0
fi

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# 安全なコマンドは自動承認
if echo "$COMMAND" | grep -qE '^(git |gh |npm |pnpm |yarn |bun |go |cargo |make |ls |cat |head |tail |wc |sort |uniq |diff |find |grep |rg |which |pwd|echo |printf |mkdir |cp |mv |chmod |touch |date |env |export |source |test |true|false|\[)'; then
  allow
fi

# それ以外はClaude Codeのデフォルト処理に委譲（ユーザーが選択）
set_claude_status waiting
exit 0
