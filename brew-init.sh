#!/bin/bash

# homebrewがインストールされていない場合はインストール
# printf "\n\e[35m💥 Start setup Homebrew \e[m\n"
# if ! type brew >/dev/null 2>&1; then
#   printf "\e[32mHomebrew Status: Install Homebrew \e[m\n"
#   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# else
#   printf "\e[33mHomebrew Status: Already installed Homebrew \e[m\n"
# fi

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [ "$(uname -m)" = "arm64" ]; then
  (
    echo
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
  ) >>/Users/${USER}/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install xcode
# Check if command line tools are installed
if ! xcode-select --print-path &>/dev/null; then
  # Install command line tools
  echo "Command line tools not found. Installing..."
  xcode-select --install
else
  echo "Command line tools are already installed."
fi

brew bundle --global
printf "\e[35m✅ Finish setup Homebrew \e[m\n"
