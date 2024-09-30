#!/bin/bash

OUTPUT_FILE="$HOME/dotfiles/volta/VoltaPackages"

# Volta Packagesの追記
function check_and_sync_volta_package() {
    package_name="$1"

    # パッケージ名がVoltaPackagesに存在するか確認し、なければ追記
    if ! grep -q "$package_name" "$OUTPUT_FILE"; then
        echo "$package_name" >>"$OUTPUT_FILE"
        echo "Added $package_name to VoltaPackages."
    else
        echo "$package_name is already in VoltaPackages."
    fi
}
