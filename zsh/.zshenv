# 非対話シェルでも brew と mise の tool を見つける。.zshrc でも読み直す (/etc/zprofile の path_helper が順序を変えるため)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$HOME/.local/share/mise/shims:$PATH"
