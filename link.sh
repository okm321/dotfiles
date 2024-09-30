#!/bin/bash

# dotfilesを配置
printf "\e[35m🔗 Start setting up a symbolic link \e[m\n"

# alacritty
if [ ! -L ~/.config/alacritty ]; then
  ln -sf ~/dotfiles/alacritty ~/.config/alacritty
  printf "  \e[32m✅ Linked alacritty \e[m\n"
else
  printf "  🔥 alacritty is already linked \n"
fi

# homebrew
if [ ! -L ~/.Brewfile ]; then
  ln -sf ~/dotfiles/homebrew/Brewfile ~/.Brewfile
  printf "  \e[32m✅ Linked Brewfile \e[m\n"
else
  printf "  🔥 Brewfile is already linked \n"
fi

# Git
if [ ! -L ~/.gitconfig ]; then
  ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
  printf "  \e[32m✅ Linked gitconfig \e[m\n"
else
  printf "  🔥 gitconfig is already linked \n"
fi

# Neovim
if [ ! -L ~/.config/nvim ]; then
  ln -sf ~/dotfiles/nvim ~/.config/nvim
  printf "  \e[32m✅ Linked nvim \e[m\n"
else
  printf "  🔥 nvim is already linked \n"
fi

# skhd
if [ ! -L ~/.config/skhd ]; then
  ln -sf ~/dotfiles/skhd ~/.config/skhd
  printf "  \e[32m✅ Linked skhd \e[m\n"
else
  printf "  🔥 skhd is already linked \n"
fi

# sheldon
if [ ! -L ~/.sheldon.toml ]; then
  ln -sf ~/dotfiles/sheldon/.sheldon.toml ~/.sheldon.toml
  printf "  \e[32m✅ Linked sheldon.toml \e[m\n"
else
  printf "  🔥 sheldon.toml is already linked \n"
fi

# starship
if [ ! -L ~/.config/starship.toml ]; then
  ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml
  printf "  \e[32m✅ Linked starship.toml \e[m\n"
else
  printf "  🔥 starship.toml is already linked \n"
fi

# tmux
if [ ! -L ~/.tmux.conf ]; then
  ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
  printf "  \e[32m✅ Linked tmux.conf \e[m\n"
else
  printf "  🔥 tmux.conf is already linked \n"
fi

# GitMux
if [ ! -L ~/.gitmux.conf ]; then
  ln -sf ~/dotfiles/tmux/.gitmux.conf ~/.gitmux.conf
  printf "  \e[32m✅ Linked gitmux.conf \e[m\n"
else
  printf "  🔥 gitmux.conf is already linked \n"
fi

# yabai
if [ ! -L ~/.config/yabai ]; then
  ln -sf ~/dotfiles/yabai ~/.config/yabai
  printf "  \e[32m✅ Linked yabai \e[m\n"
else
  printf "  🔥 yabai is already linked \n"
fi

# zsh
if [ ! -L ~/.zshrc ]; then
  ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
  printf "  \e[32m✅ Linked zshrc \e[m\n"
else
  printf "  🔥 zshrc is already linked \n"
fi

printf "\e[35m✅ Finish setting up a symbolic link \e[m\n"
