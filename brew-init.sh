#!/bin/bash

# homebrewがインストールされていない場合はインストール
printf "\n\e[35m💥 Start setup Homebrew \e[m\n"
if ! type brew >/dev/null 2>&1; then
  printf "\e[32mHomebrew Status: Install Homebrew \e[m\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  printf "\e[33mHomebrew Status: Already installed Homebrew \e[m\n"
fi

brew bundle --global
printf "\e[35m✅ Finish setup Homebrew \e[m\n"
