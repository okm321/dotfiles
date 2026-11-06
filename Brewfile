# マシン共通。install.sh が hosts/<host>/Brewfile と連結して読む

# brew 6 以降は非公式 tap を trust しないと読み込まない
tap "raine/workmux", trusted: true
tap "umputun/apps", trusted: true
tap "morantron/tmux-fingers", trusted: true
tap "nikitabobko/tap", trusted: true
tap "felixkratz/formulae", trusted: true
tap "leoafarias/fvm", trusted: true

# シェル基盤
brew "zsh"
brew "bash"
brew "git"
brew "gh" # git の credential helper なので mise activate 前の PATH でも要る
brew "tmux"
brew "mise"
# .zshrc が mise activate より前に呼ぶので mise には置けない
brew "sheldon"
brew "starship"
brew "direnv"
brew "deno" # zeno-bootstrap.zsh が読み込み時に PATH を見る

# CLI
brew "gnu-sed" # gsed として入る
brew "tree"
brew "htop"
brew "p7zip"
brew "chafa"
brew "gitmux"
brew "httpie"
brew "awscli"
brew "tenv"

# メディア・画像処理
brew "ffmpeg"
brew "imagemagick"
brew "poppler"

# 開発系
brew "cocoapods"
brew "gopls"
brew "typos-lsp"
brew "redis"
brew "postgresql@18", link: true # keg-only なので psql を PATH に出す (サーバは起動しない)
brew "pgcli"
brew "pam-reattach" # sudo_local の pam_reattach.so

# Tap
brew "raine/workmux/workmux"
brew "umputun/apps/revdiff"
brew "morantron/tmux-fingers/tmux-fingers"
brew "leoafarias/fvm/fvm"
brew "felixkratz/formulae/borders" # aerospace.toml の起動コマンドから呼ぶ

# ターミナル / ウィンドウ管理 / ランチャー
cask "ghostty"
cask "nikitabobko/tap/aerospace"
cask "raycast"

# 開発ツール
cask "gcloud-cli"
cask "session-manager-plugin"
# mise の npm だと provenance の無い版で trust policy に止められる
cask "copilot-language-server"
cask "vercel"
cask "tableplus"
cask "postman"
cask "docker-desktop"
cask "drawio"
cask "android-studio"

# ブラウザ / コミュニケーション
cask "google-chrome"
cask "slack"

# 生産性 / デザイン
cask "obsidian"
cask "figma"
cask "claude"

# ユーティリティ
cask "1password"
cask "1password-cli"
cask "cleanshot"
cask "nani"
cask "voiceink"

# フォント
cask "font-maple-mono-nf-cn"
