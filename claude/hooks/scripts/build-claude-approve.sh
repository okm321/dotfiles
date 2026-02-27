#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_NAME="CCWatcher"
APP_DIR="$HOME/Applications/$APP_NAME.app"
SRC="$SCRIPT_DIR/claude-approve.swift"
OLD_APP="$HOME/Applications/ClaudeApprove.app"

echo "Compiling..."
swiftc -O -o "/tmp/$APP_NAME" "$SRC" -framework AppKit -framework SwiftUI

# 旧アプリを削除
[ -d "$OLD_APP" ] && rm -rf "$OLD_APP"

echo "Creating app bundle: $APP_DIR"
mkdir -p "$APP_DIR/Contents/MacOS"
mv "/tmp/$APP_NAME" "$APP_DIR/Contents/MacOS/$APP_NAME"

cat > "$APP_DIR/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>CCWatcher</string>
    <key>CFBundleIdentifier</key>
    <string>com.cc.watcher</string>
    <key>CFBundleName</key>
    <string>CC Watcher</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

# CLI用シンボリックリンク（フックスクリプトから呼ばれる）
ln -sf "$APP_DIR/Contents/MacOS/$APP_NAME" "$SCRIPT_DIR/claude-approve"

# ランチャーコマンド
LAUNCHER="$HOME/.local/bin/cc-watcher"
mkdir -p "$(dirname "$LAUNCHER")"
cat > "$LAUNCHER" << 'SCRIPT'
#!/bin/bash
pkill -f "CCWatcher.app" 2>/dev/null && sleep 1
open "$HOME/Applications/CCWatcher.app"
echo "CC Watcher started."
SCRIPT
chmod +x "$LAUNCHER"

# 旧ランチャーを削除
rm -f "$HOME/.local/bin/claude-watcher"

echo "Done!"
echo "  App: $APP_DIR"
echo "  CLI: $SCRIPT_DIR/claude-approve -> app binary"
echo "  Launcher: cc-watcher"
