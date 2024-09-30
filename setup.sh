#!/bin/bash

printf "\n\e[36m💊💊 Start setup my dotfiles 💊💊\e[m\n\n"

set -ue

# dotfilesのシンボリックリンクを作成する
source ~/dotfiles/link.sh

# Brewfileに記載されているパッケージをインストール
source ~/dotfiles/brew-init.sh

# zshをbrewのものに置き換え
source ~/dotfiles/replace-zsh.sh

# gitをbrewのものに置き換え
source ~/dotfiles/replace-git.sh

printf "\n\e[36m🎊🎊 Finish setup my dotfiles 🎊🎊\e[m\n"
