#!/bin/bash

# miseがインストールされていない場合はスキップ
if ! command -v mise &>/dev/null; then
  echo "mise is not installed. Install it via 'brew install mise' first."
  exit 1
fi

# グローバル設定のシンボリックリンク
mkdir -p ~/.config/mise
if [ ! -L ~/.config/mise/config.toml ]; then
  ln -sf ~/dotfiles/mise/config.toml ~/.config/mise/config.toml
  printf "  \e[32m✅ Linked mise/config.toml \e[m\n"
fi

# ツールをインストール
mise install
