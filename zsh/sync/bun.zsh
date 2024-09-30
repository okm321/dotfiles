#!/bin/bash

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/okamotonaofumi/.bun/_bun" ] && source "/Users/okamotonaofumi/.bun/_bun"
