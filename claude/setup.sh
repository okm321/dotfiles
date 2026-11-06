#!/bin/bash
# Setup Claude Code plugins and MCP servers

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SETTINGS_FILE="$SCRIPT_DIR/settings.json"
MCP_FILE="$SCRIPT_DIR/mcp-servers.json"

# 実行時 cwd から .claude-config-dir マーカーを上方向に探し、対象 config dir を確定する
# (zsh の claude ラッパーと同じ判定。シェルの環境変数には依存しない)
dir="$PWD"
while [ "$dir" != "/" ]; do
  if [ -f "$dir/.claude-config-dir" ]; then
    CLAUDE_CONFIG_DIR="$(cat "$dir/.claude-config-dir")"
    export CLAUDE_CONFIG_DIR
    break
  fi
  dir="$(dirname "$dir")"
done
echo "Target config dir: ${CLAUDE_CONFIG_DIR:-$HOME/.claude (default)}"

# Install plugins
echo "=== Installing Plugins ==="

if [[ ! -f "$SETTINGS_FILE" ]]; then
  echo "Warning: settings.json not found"
else
  # GitHub マーケットプレイスを登録
  jq -r '.extraKnownMarketplaces // {} | .[].source | select(.source == "github") | .repo' "$SETTINGS_FILE" | sort -u | while read -r repo; do
    echo "Adding marketplace: $repo"
    claude plugin marketplace add "$repo" 2>/dev/null || true
  done

  # enabledPlugins からプラグインをインストール
  plugins=$(jq -r '.enabledPlugins // {} | keys[]' "$SETTINGS_FILE")
  if [[ -n "$plugins" ]]; then
    echo "$plugins" | while read -r plugin; do
      echo "Installing plugin: $plugin"
      claude plugin install "$plugin"
    done
  else
    echo "No plugins to install"
  fi
fi

# Setup claude-seo Python dependencies (フル機能用)
# agents は素の python3 を呼ぶため、user site に入れて PATH 操作を不要にする
# （--break-system-packages は Homebrew python の PEP668 制約を回避。システム本体は汚さず user 領域のみ）
echo ""
echo "=== Setting up claude-seo (Python) ==="

SEO_VERSION="v2.2.0"
if jq -e '.enabledPlugins["claude-seo@agricidaniel-claude-seo"]' "$SETTINGS_FILE" >/dev/null 2>&1; then
  if ! command -v python3 >/dev/null 2>&1; then
    echo "Warning: python3 が見つかりません。claude-seo の Python セットアップをスキップ"
  else
    # requirements.txt はプラグイン配置先を優先、無ければ GitHub から取得
    REQ=$(find "$HOME/.config/claude/plugins" -name requirements.txt -path '*claude-seo*' 2>/dev/null | head -1)
    TMP_REQ=""
    if [[ -z "$REQ" ]]; then
      TMP_REQ=$(mktemp)
      echo "Fetching requirements.txt ($SEO_VERSION) from GitHub..."
      curl -fsSL "https://raw.githubusercontent.com/AgriciDaniel/claude-seo/$SEO_VERSION/requirements.txt" -o "$TMP_REQ" && REQ="$TMP_REQ"
    fi

    if [[ -n "$REQ" && -f "$REQ" ]]; then
      echo "Installing Python deps into user site..."
      python3 -m pip install --user --break-system-packages -r "$REQ"
      echo "Installing Playwright Chromium (visual analysis)..."
      python3 -m playwright install chromium || echo "  (playwright skip)"
    else
      echo "Warning: requirements.txt を取得できず。Python セットアップをスキップ"
    fi
    [[ -n "$TMP_REQ" ]] && rm -f "$TMP_REQ"

    # weasyprint の PDF 出力に必要なシステムライブラリ
    if command -v brew >/dev/null 2>&1 && ! brew list pango >/dev/null 2>&1; then
      echo "Installing pango (PDF export 用)..."
      brew install pango || echo "  (pango skip)"
    fi
  fi
else
  echo "claude-seo は enabledPlugins に無いためスキップ"
fi

# Setup MCP servers
echo ""
echo "=== Setting up MCP Servers ==="

if [[ ! -f "$MCP_FILE" ]]; then
  echo "Warning: mcp-servers.json not found"
else
  # add-json は既存サーバーを上書きしないため、削除してから登録する
  jq -r 'keys[]' "$MCP_FILE" | while read -r name; do
    echo "Adding MCP server: $name"
    claude mcp remove "$name" --scope user >/dev/null 2>&1
    claude mcp add-json "$name" "$(jq -c --arg n "$name" '.[$n]' "$MCP_FILE")" --scope user
  done
fi

echo ""
echo "Done!"
