#!/bin/bash

eval "$(/opt/homebrew/bin/brew shellenv)"

# brew shellenv が /opt/homebrew/bin を先頭に足すので、shim (workmux) 置き場を先頭に戻す
path=("$HOME/dotfiles/bin" $path)
typeset -U path
