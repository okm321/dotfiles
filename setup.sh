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

# miseをセットアップ
source ~/dotfiles/mise/mise-init.sh

# Bunをインストール
source ~/dotfiles/bun/bun-init.sh

# TPMをクローン
source ~/dotfiles/tmux/tpm-init.sh

printf "\n\e[36m🎊🎊 Finish setup my dotfiles 🎊🎊\e[m\n"
printf "\n\e[36m🎉🎉 Please restart your terminal 🎉🎉\e[m\n"
printf "\n\e[36m You have to install tmux package \e[m\n"
