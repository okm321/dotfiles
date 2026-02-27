#!/bin/bash
# .claude/plans/ を .git/info/exclude に追加する（未登録の場合のみ）

GIT_DIR=$(git rev-parse --git-dir 2>/dev/null) || exit 0

EXCLUDE_FILE="$GIT_DIR/info/exclude"
ENTRY=".claude/plans/"

mkdir -p "$GIT_DIR/info"

if [ -f "$EXCLUDE_FILE" ]; then
  grep -qxF "$ENTRY" "$EXCLUDE_FILE" && exit 0
fi

echo "$ENTRY" >> "$EXCLUDE_FILE"
