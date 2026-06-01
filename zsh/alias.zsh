#!/bin/bash

alias ls="lsd"
alias l="lsd -l"
alias ll="lsd -l"
alias la="lsd -a"
alias lla="lsd -la"
alias lt="lsd --tree"
alias vi="nvim"
alias vim="nvim"
alias view="nvim -R"
alias c='clear'
alias reload='exec $SHELL -l'
alias cdf='cd "$(dirname "$(fzf --preview="bat --color=always  --height 100% {}")")"'
alias tmux-load="tmux source-file ~/.config/tmux/.tmux.conf"
# IDEライクのレイアウトを作成する関数
# 構成 (高さ 上 75% / 下 25% 、 横は 上 70/30 ・ 下 50/50):
#   ┌──────────────┬──────┐
#   │     nvim     │ chat │
#   ├──────────┬───┴──────┤
#   │    sh    │    sh    │
#   └──────────┴──────────┘
function create_ide_layout() {
  local p_top=$(tmux display-message -p '#{pane_id}')
  local p_bottom=$(tmux split-window -v -p 25 -P -F '#{pane_id}')
  tmux split-window -h -p 50 -t "$p_bottom"
  local p_chat=$(tmux split-window -h -p 30 -t "$p_top" -P -F '#{pane_id}')
  tmux select-pane -t "$p_chat" -T 'ai chat'
  tmux select-pane -t "$p_top"
}
alias ide='create_ide_layout'
function ghql() {
  local dir=$(ghq list -p | fzf --preview "eza -la {}" --prompt="🔍 ghq Search ")
  [ -n "$dir" ] && builtin cd "$dir"
}

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
alias wt="workmux"

# Docker context 切り替え (orbstack ⇔ Docker Desktop)
alias docker-orb='docker context use orbstack'
alias docker-dd='docker context use desktop-linux'

function tmux-setup() {
  local profile="$1"
  if [[ -z "$profile" ]]; then
    echo "使い方: tmux-setup <profile>"
    echo "設定ファイル: ~/dotfiles/zsh/.tmux-setup/<profile>.conf"
    return 1
  fi

  local config="$HOME/dotfiles/zsh/.tmux-setup/${profile}.conf"
  if [[ ! -f "$config" ]]; then
    echo "設定ファイルがありません: $config"
    return 1
  fi

  local first_session=""
  while IFS='=' read -r name dir; do
    [[ -z "$name" || "$name" == \#* ]] && continue
    dir=$(eval echo "$dir")
    [[ -z "$first_session" ]] && first_session="$name"
    if ! tmux has-session -t "$name" 2>/dev/null; then
      tmux new-session -d -s "$name" -c "$dir" \; \
        split-window -v -p 30 -c "$dir" \; \
        split-window -h -p 50 -c "$dir" \; \
        select-pane -t 0
    fi
  done < "$config"

  if [ -n "$TMUX" ]; then
    tmux switch-client -t "$first_session"
  else
    tmux attach-session -t "$first_session"
  fi
}

function claude-mute() {
  local flag="/tmp/claude-sound-muted"
  if [ -f "$flag" ]; then
    rm "$flag"
    echo "🔔 Claude通知音: ON"
  else
    touch "$flag"
    echo "🔕 Claude通知音: OFF"
  fi
}
