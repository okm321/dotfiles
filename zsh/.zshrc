#!/bin/bash

# zshの読み込み時間を表示するときはコメントアウトを外す
# zmodload zsh/zprof

# Deno (sheldon より先に読み込む。zeno.zsh が依存)
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

export SHELDON_CONFIG_FILE=$HOME/.sheldon.toml
eval "$(sheldon source)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Google Cloud SDK
[ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] && . "$HOME/google-cloud-sdk/path.zsh.inc"
[ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] && . "$HOME/google-cloud-sdk/completion.zsh.inc"

# uv (Python package manager)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# ~/.local/bin (claude code 公式 native installer の置き場など)
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

eval "$(direnv hook zsh)"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
# source ~/.safe-chain/scripts/init-posix.sh # Safe-chain Zsh initialization script

eval "$(mise activate zsh)"

eval "$(zoxide init zsh --no-cmd)"
source ~/dotfiles/zsh/zoxide.zsh

export XDG_CONFIG_HOME="$HOME/.config"

export CLAUDE_CONFIG_DIR="$HOME/.config/claude"

export EDITOR="nvim"

# Load local secrets (not committed to dotfiles)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# humanlog
export PATH=~/.humanlog/bin:$PATH

