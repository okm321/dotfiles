#!/bin/bash

# Voltaのパッケージディレクトリ
VOLTA_PACKAGES_DIR="$HOME/.volta/tools/image/packages"

# 出力ファイル名
OUTPUT_FILE="$HOME/dotfiles/volta/VoltaPackages"

# 出力ファイルをクリアしてから生成開始
>"$OUTPUT_FILE"

# パッケージをリストアップ
for scope_dir in "$VOLTA_PACKAGES_DIR"/*; do
  if [[ -d "$scope_dir" ]]; then
    scope=$(basename "$scope_dir")
    # スコープが"@"で始まる場合、スコープ付きのパッケージ名を生成
    if [[ "$scope" =~ ^@ ]]; then
      for package_dir in "$scope_dir"/*; do
        if [[ -d "$package_dir" ]]; then
          package=$(basename "$package_dir")
          echo "$scope/$package" >>"$OUTPUT_FILE"
        fi
      done
    else
      # スコープがない場合、そのディレクトリをパッケージ名として扱う
      echo "$scope" >>"$OUTPUT_FILE"
    fi
  fi
done
