#!/bin/bash

export FZF_DEFAULT_OPTS="--ansi -e --ignore-case --prompt='🔍 ' --layout=reverse --border=rounded --height 100% "
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=header,grid --line-range :100 {} --theme="Nord"' --prompt='🔍 Search File ' --bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
export FZF_CTRL_R_OPTS="--prompt='🔍 Search History '"
export FZF_ALT_C_OPTS="--preview 'eza {} -h -T -F  --no-user --no-time --no-filesize --no-permissions --long | head -200' --prompt='🔍 Search Directory '"
export FZF_DEFAULT_COMMAND="fd -H -E .git -E node_modules --color=always"
export FZF_CTRL_T_COMMAND="fd --type f -H -E .git -E node_modules"
export FZF_ALT_C_COMMAND="fd --type d -H -E .git -E node_modules"
export FZF_TMUX_OPTS="-p 80%"

# fzfのキーバインドのみ読み込み（補完はzenoに任せる）
# Ctrl+T: ファイル検索, Ctrl+R: 履歴検索（zenoで上書き）, Alt+C: ディレクトリ移動
source <(fzf --zsh | grep -v 'bindkey.*fzf-completion')
