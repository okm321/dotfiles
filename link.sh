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

# Claude (ファイル単位でリンク)
mkdir -p ~/.config/claude
for item in settings.json CLAUDE.md skills agents rules hooks; do
  if [ -e ~/dotfiles/claude/$item ]; then
    if [ ! -L ~/.config/claude/$item ]; then
      ln -sf ~/dotfiles/claude/$item ~/.config/claude/$item
      printf "  \e[32m✅ Linked claude/$item \e[m\n"
    else
      printf "  🔥 claude/$item is already linked \n"
    fi
  fi
done

# homebrew
if [ ! -L ~/.Brewfile ]; then
  ln -sf ~/dotfiles/homebrew/Brewfile ~/.Brewfile
  printf "  \e[32m✅ Linked Brewfile \e[m\n"
else
  printf "  🔥 Brewfile is already linked \n"
fi

# Ghostty
if [ ! -L ~/.config/ghostty ]; then
  ln -sf ~/dotfiles/ghostty ~/.config/ghostty
  printf "  \e[32m✅ Linked ghostty \e[m\n"
else
  printf "  🔥 ghostty is already linked \n"
fi

# Git
if [ ! -L ~/.gitconfig ]; then
  ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig
  printf "  \e[32m✅ Linked gitconfig \e[m\n"
else
  printf "  🔥 gitconfig is already linked \n"
fi

# lazygit
if [ ! -L ~/.config/lazygit ]; then
  ln -sf ~/dotfiles/lazygit ~/.config/lazygit
  printf "  \e[32m✅ Linked lazygit \e[m\n"
else
  printf "  🔥 lazygit is already linked \n"
fi

# aider
if [ ! -L ~/.aider.conf.yml ]; then
  ln -sf ~/dotfiles/aider/.aider.conf.yml ~/.aider.conf.yml
  printf "  \e[32m✅ Linked aider.conf \e[m\n"
else
  printf "  🔥 aider.conf is already linked \n"
fi
if [ ! -L ~/.aider.model.settings.yml ]; then
  ln -sf ~/dotfiles/aider/.aider.model.settings ~/.aider.model.settings.yml
  printf "  \e[32m✅ Linked aider.model.settings \e[m\n"
else
  printf "  🔥 aider.model.settings is already linked \n"
fi

# Neovim
if [ ! -L ~/.config/nvim ]; then
  ln -sf ~/dotfiles/nvim ~/.config/nvim
  printf "  \e[32m✅ Linked nvim \e[m\n"
else
  printf "  🔥 nvim is already linked \n"
fi

# Raycast
if [ ! -L ~/.config/raycast/scripts ]; then
  ln -sf ~/dotfiles/raycast/scripts ~/.config/raycast/scripts
  chmod +x ~/.config/raycast/scripts/*
  printf "  \e[32m✅ Linked raycast \e[m\n"
else
  printf "  🔥 raycast is already linked \n"
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

# aerospace
if [ ! -L ~/.config/aerospace ]; then
  ln -sf ~/dotfiles/aerospace ~/.config/aerospace
  printf "  \e[32m✅ Linked aerospace \e[m\n"
else
  printf "  🔥 aerospace is already linked \n"
fi

# workmux
mkdir -p ~/.config/workmux
if [ ! -L ~/.config/workmux/config.yaml ]; then
  ln -sf ~/dotfiles/workmux/config.yaml ~/.config/workmux/config.yaml
  printf "  \e[32m✅ Linked workmux \e[m\n"
else
  printf "  🔥 workmux is already linked \n"
fi

# yazi
if [ ! -L ~/.config/yazi ]; then
  ln -sf ~/dotfiles/yazi ~/.config/yazi
  printf "  \e[32m✅ Linked yazi \e[m\n"
else
  printf "  🔥 yazi is already linked \n"
fi

# zeno
if [ ! -L ~/.config/zeno ]; then
  ln -sf ~/dotfiles/zeno ~/.config/zeno
  printf "  \e[32m✅ Linked zeno \e[m\n"
else
  printf "  🔥 zeno is already linked \n"
fi

# zsh
if [ ! -L ~/.zshrc ]; then
  ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
  printf "  \e[32m✅ Linked zshrc \e[m\n"
else
  printf "  🔥 zshrc is already linked \n"
fi

printf "\e[35m✅ Finish setting up a symbolic link \e[m\n"
