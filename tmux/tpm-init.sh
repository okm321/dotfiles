#!/bin/bash

printf "\e[35m🎿 TPM clone \e[m\n"

if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  printf "  \e[32m✅ Cloned TPM \e[m\n"
else
  printf "  🔥 TPM is already cloned \n"
fi
