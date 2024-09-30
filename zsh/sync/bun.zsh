#!/bin/bash

export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/Users/okm/.bun/_bun" ] && source "/Users/okm/.bun/_bun"
