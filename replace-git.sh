#!/bin/bash

# Brewでgitがインストールされているか確認
printf "\n\e[36m🍺 Start replacing git with Homebrew 🍺\e[m\n"
if ! brew list git &>/dev/null; then
  printf "  \e[32m🦒 Git is not installed, starting installation... \e[m\n"
  brew install git
else
  echo "  Git is already installed."
fi

# Brewでインストールされたgitのパスを取得
GIT_PATH=$(brew --prefix)/bin/git

# 現在のgitのパスを確認
CURRENT_GIT_PATH=$(which git)

# デフォルトのgitがすでにbrewのものかどうか確認
if [ "$CURRENT_GIT_PATH" == "$GIT_PATH" ]; then
  echo "  Git installed via Homebrew is already set as the default."
else
  printf "  \e[33mSetting Git installed via Homebrew as the default... \n"

  # パスを追加
  SHELL_PATH_FILE="$HOME/dotfiles/zsh/sync/path.zsh"
  echo "export PATH=\"$GIT_PATH:\$PATH\"" >>"$SHELL_PATH_FILE"

  # シェル設定を再読み込み
  source "$HOME"/.zshrc

  printf "  \e[32mFinish replacing git with Homebrew \e[m\n"
fi
