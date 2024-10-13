#!/bin/bash

# Voltaがインストールされていない場合はインストール
if ! command -v volta &>/dev/null; then
  curl https://get.volta.sh | bash -s -- --skip-setup
  export VOLTA_HOME=~/.volta
  grep --silent "$VOLTA_HOME/bin" <<<$PATH || export PATH="$VOLTA_HOME/bin:$PATH"
  volta install node
  volta install yarn
  volta install npm
fi

PACKAGE_FILE="$HOME/dotfiles/volta/VoltaPackages"

if [[ -f "$PACKAGE_FILE" ]]; then
  while read -r package; do
    if [ -n "$package" ]; then
      volta install "$package"
    fi
  done <"$PACKAGE_FILE"
else
  echo "No VoltaPackages file found."
  exit 1
fi
