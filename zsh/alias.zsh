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
alias cdf='cd "$(dirname "$(fzf --preview="bat --color=always {}")")"'
alias tmux-load="tmux source-file ~/.config/tmux/.tmux.conf"
