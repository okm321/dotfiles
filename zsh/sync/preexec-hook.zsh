#!/bin/bash

source ~/dotfiles/zsh/sync/check-and-sync-brewfile.zsh

_custom_preexec_hook() {
  if [[ "$1" == brew* ]]; then
    check_and_sync_brewfile
  fi
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _custom_preexec_hook
