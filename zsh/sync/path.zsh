#!/bin/bash

# Git
export PATH="/opt/homebrew/bin/git:$PATH"
# Go
export PATH="$HOME/go/bin:$PATH"

# Zsh補完関連の設定
FPATH="/opt/homebrew/share/zsh-completions:$FPATH"
FPATH="/opt/homebrew/share/zsh/site-functions:$FPATH"
