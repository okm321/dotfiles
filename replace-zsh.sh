#!/bin/bash

# Brewでzshがインストールされているか確認
printf "\n\e[33m⚡\e[35mStart setup zsh \e[m\n"
if ! brew list zsh &>/dev/null; then
  printf "  \e[32mZsh is not installed, starting installation... \e[m\n"
  brew install zsh
else
  printf "  Zsh is already installed. \n"
fi

# インストールしたzshのパスを取得
ZSH_PATH=$(brew --prefix)/bin/zsh

# インストールされたzshがシェルとして許可されているか確認し、追加
if ! grep -Fxq "$ZSH_PATH" /etc/shells; then
  echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

CURRENT_SHELL=$(dscl . -read ~/ UserShell | awk '{print $2}')

# デフォルトシェルがすでにインストールしたzshか確認し、違う場合のみ変更
if [ "$CURRENT_SHELL" != "$ZSH_PATH" ]; then
  printf "  \e[32m♻️  Changing default shell to $ZSH_PATH... \e[m\n"
  chsh -s "$ZSH_PATH"
  printf "  \e[32m✅ Default shell changed to $ZSH_PATH. Please restart terminal. \e[m\n"]"
else
  echo " The default shell is already set to $ZSH_PATH.
fi

printf "\e[35m✅ Finish setup zsh \e[m\n"
