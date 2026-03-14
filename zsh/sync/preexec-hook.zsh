#!/bin/bash

source ~/dotfiles/zsh/sync/check-and-sync-volta-package.zsh
source ~/dotfiles/zsh/sync/check-and-sync-brewfile.zsh

_custom_preexec_hook() {
  # npmのグローバルインストールを検知
  if [[ "$1" == npm\ install\ -g* ]]; then
    package=$(echo "$1" | awk '{print $4}')
    check_and_sync_volta_package "$package"
  # yarnのグローバルインストールを検知
  elif [[ "$1" == yarn\ global\ add* ]]; then
    package=$(echo "$1" | awk '{print $4}')
    check_and_sync_volta_package "$package"
  fi

  if [[ "$1" == brew* ]]; then
    check_and_sync_brewfile
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _custom_preexec_hook
