#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Restart AeroSpace
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🔄
# @raycast.packageName System

# 強制終了
pkill -9 AeroSpace 2>/dev/null || killall -9 AeroSpace 2>/dev/null

# 少し待つ
sleep 0.5

# 再起動
open -a AeroSpace

echo "AeroSpace restarted"
