#!/bin/bash

# dotfilesを配置
echo "--- Link dotfiles Start ---"

# alacritty
ln -sf ~/dotfiles/alacritty ~/.config/alacritty

# homebrew
ln -sf ~/dotfiles/homebrew/Brewfile ~/.Brewfile

# Git
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Neovim
ln -sf ~/dotfiles/nvim ~/.config/nvim

# skhd
ln -sf ~/dotfiles/skhd ~/.config/skhd

# sheldon
ln -sf ~/dotfiles/sheldon/.sheldon.toml ~/.sheldon.toml

# starship
ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml

# tmux/GitMux
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/tmux/.gitmux.conf ~/.gitmux.conf

# yabai
ln -sf ~/dotfiles/yabai ~/.config/yabai

# zsh
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc

echo "--- Link dotfiles Finish ---"
