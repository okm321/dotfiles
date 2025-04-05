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
function create_ide_layout() {
  tmux split-window -v -p 30 #ウィンドウを垂直に分割し、新しいペインを作成
  tmux split-window -h -p 50 #新しく作成されたペインをさらに水平に分割
}
alias ide='create_ide_layout'
