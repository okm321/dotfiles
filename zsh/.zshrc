#!/bin/bash

# zshの読み込み時間を表示するときはコメントアウトを外す
# zmodload zsh/zprof

export SHELDON_CONFIG_FILE=$HOME/.sheldon.toml
eval "$(sheldon source)"

# zpro

# bun completions
[ -s "/Users/okm/.bun/_bun" ] && source "/Users/okm/.bun/_bun"

# pnpm
export PNPM_HOME="/Users/okm/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/okm/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/okm/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/okm/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/okm/google-cloud-sdk/completion.zsh.inc'; fi

. "$HOME/.local/bin/env"
