# brew のzsh-completions を fpath に追加
fpath=(/opt/homebrew/opt/zsh-completions/share/zsh-completions $fpath)

# 1日1回だけ compinit を再生成、それ以外はキャッシュを使う
autoload -Uz compinit
if [[ -z ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -C
else
  compinit
fi

# 補完候補をメニュー表示（↑↓で選択可能）
zstyle ':completion:*' menu select
# 説明をグループごとに表示
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%F{cyan}-- %d --%f%b'
# 大文字小文字を区別しない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補にLS_COLORSで色付け
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# 補完メニュー中にEnterでコマンド実行（候補確定ではなく）
zmodload zsh/complist
bindkey -M menuselect '^m' .accept-line
