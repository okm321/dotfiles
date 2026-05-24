#!/bin/bash

# Nix (nix-darwin + Home Manager) - 必ず先頭に置く
# /etc/profiles/per-user/<user>/bin : home-manager の useUserPackages = true でここに集約
# /run/current-system/sw/bin        : nix-darwin が管理するシステムレベルのパッケージ
# $HOME/.nix-profile/bin            : standalone home-manager 用
# /nix/var/nix/profiles/default/bin : Nix 本体や upstream nix command
export PATH="/etc/profiles/per-user/$USER/bin:/run/current-system/sw/bin:$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# Git
export PATH="/opt/homebrew/bin/git:$PATH"
# Go
export PATH="$HOME/go/bin:$PATH"
