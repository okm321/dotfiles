#!/bin/bash

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS="--ansi -e --ignore-case --prompt='Search Directory ' --layout=reverse --border=rounded --height 100% "
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :100 {} --theme="Nord"' --prompt='🔍 Search File ' --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
export FZF_ALT_C_OPTS="--preview 'eza {} -h -T -F  --no-user --no-time --no-filesize --no-permissions --long | head -200' --prompt='🔍 Search Directory '"
export FZF_DEFAULT_COMMAND="fd -H -E .git -E node_modules --color=always"
export FZF_CTRL_T_COMMAND="fd --type f -H -E .git -E node_modules"
export FZF_ALT_C_COMMAND="fd --type d -H -E .git -E node_modules"
export FZF_TMUX_OPTS="-p 80%"

# fzfの設定
source <(fzf --zsh)
