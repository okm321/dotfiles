#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# launchdはシェルプロファイルを読まないのでPATHを設定
export PATH="$HOME/.local/bin:/opt/homebrew/bin:/usr/local/bin:$HOME/.local/share/mise/shims:$PATH"

# ログディレクトリ
mkdir -p "$SCRIPT_DIR/logs"

python3 "$SCRIPT_DIR/digest.py"
