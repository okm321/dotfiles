#!/bin/bash

source ~/dotfiles/zsh/sync/check-and-sync-volta-package.zsh
source ~/dotfiles/zsh/sync/check-and-sync-brewfile.zsh

autoload -Uz add-zsh-hook
add-zsh-hook preexec() {
  echo "kokoyade"

  # npmのグローバルインストールを検知
  if [[ "$1" == npm\ install\ -g* ]]; then
    # npmでインストールされたパッケージ名を抽出
    package=$(echo "$1" | awk '{print $4}')

    # パッケージをVoltaPackagesに追加
    check_and_sync_volta_package "$package"

  # yarnのグローバルインストールを検知
  elif [[ "$1" == yarn\ global\ add* ]]; then
    # yarnでインストールされたパッケージ名を抽出
    package=$(echo "$1" | awk '{print $4}')

    # パッケージをVoltaPackagesに追加
    check_and_sync_volta_package "$package"
  fi

  # if [[ "$1" == brew && "$2" =~ ^(install|uninstall|upgrade|cask|tap)$ ]]; then
  #   check_and_sync_brewfile
  # fi
  if [[ "$1" == brew* ]]; then
    check_and_sync_brewfile
  fi
}
