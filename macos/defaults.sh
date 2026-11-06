#!/bin/sh
set -eu

# NSGlobalDomain
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# 最速 (画像のスライダー右端)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain "com.apple.swipescrolldirection" -bool false
defaults write NSGlobalDomain "com.apple.trackpad.scaling" -float 2.0
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write NSGlobalDomain _HIHideMenuBar -bool false

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 36
defaults write com.apple.dock magnification -bool false
defaults write com.apple.dock show-process-indicators -bool true
defaults write com.apple.dock mineffect -string "genie"
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1

# Finder
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder CreateDesktop -bool false
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# screencapture
mkdir -p "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/Screenshots"
defaults write com.apple.screencapture type -string "png"

# trackpad (内蔵 / Bluetooth の両ドメインに書く)
# タップでクリックを無効化 (物理クリックのみ)
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool false
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool false

# マウス軌跡速度 / マウススクロール速度
defaults write NSGlobalDomain "com.apple.mouse.scaling" -float 2.0
defaults write NSGlobalDomain "com.apple.scrollwheel.scaling" -float 0.3125

# 拡大/縮小 (2 本指ピンチ), 回転 (2 本指), スマートズーム (2 本指ダブルタップ)
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -int 1
# 4 本指ピンチ / 5 本指ピンチ
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2

# 日本語入力 (ことえり) のライブ変換を無効化
defaults write com.apple.inputmethod.Kotoeri JIMPrefLiveConversionKey -bool false

killall Dock Finder SystemUIServer 2>/dev/null || true
echo "一部の設定はログアウトして再ログインすると反映されます。"
