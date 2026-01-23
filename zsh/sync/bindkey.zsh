bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# fzfのAlt+C (Esc+c) バインドを無効化
# Escを押した後400ms以内にcを押すとfzfが起動してしまうのを防ぐ
bindkey -r '\ec'
