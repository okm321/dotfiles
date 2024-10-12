#!/bin/bash

if ! command -v bun &>/dev/null; then
  echo "Bun is not installed. Installing Bun..."
  curl -fsSL https://bun.sh/install | bash
  export BUN_INSTALL="$HOME/.bun"
  grep --silent "$BUN_INSTALL/bin" <<<$PATH || export PATH="$BUN_INSTALL/bin:$PATH"
  echo "Bun installation complete!"
else
  echo "Bun is already installed."
fi
