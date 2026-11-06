{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      # brew 7 で --cleanup が廃止。nix-darwin 25.11 が追従したら "uninstall" に戻す
      cleanup = "none";
    };

    # homebrew.taps は flake.nix で nix-homebrew.taps から自動同期される
    # (modules には書かない)

    brews = [
      "osx-cross/avr/avr-gcc@9"
      "raine/workmux/workmux"
      "umputun/apps/revdiff"  # diff レビュー TUI (Claude Code plugin と併用)
      "morantron/tmux-fingers/tmux-fingers"
      "k1low/tap/mo"  # Markdown viewer (nixpkgs の mo は別物 = moustache template)
      "ical-buddy"
      "leoafarias/fvm/fvm"  # Flutter SDK バージョン管理 (nixpkgs の fvm は 0.9.3 と古い)
    ];

    # mas が新版 (v2+) で `mas get <id>` サブコマンドを削除したため
    # Homebrew bundle 経由の install が失敗する。一旦コメントアウトして手動 install:
    # - Xcode: App Store で検索 → install
    # - Amazon Kindle: App Store で検索 → install
    # 将来 Homebrew bundle 側が `mas install` に対応したら復活
    # masApps = {
    #   Xcode = 497799835;
    #   "Amazon Kindle" = 302584613;
    # };

    casks = [
      # ターミナル / ウィンドウ管理 / ランチャー
      "nikitabobko/tap/aerospace"
      "ghostty"
      "raycast"

      # 開発ツール / API
      "google-cloud-sdk"
      "tableplus"
      "postman"
      "orbstack"
      "docker-desktop"
      "drawio"

      # エディタ / IDE
      "zed"
      "visual-studio-code"
      "android-studio"

      # ブラウザ
      "google-chrome"
      # "dia"  # Homebrew cask 未登録のため手動管理 (/Applications/Dia.app)

      # コミュニケーション
      "slack"

      # 生産性 / ノート / デザイン
      "notion"
      "obsidian"
      "figma"
      "claude"

      # メディア
      "spotify"

      # ユーティリティ
      "1password"
      "1password-cli"
      "cleanshot"
      "clipy"
      "steipete/tap/codexbar"
      "nani"
      "voiceink"
      "keycastr"

      # Microsoft Office (一括)
      "microsoft-office"

      # フォント
      "font-maple-mono-nf-cn"
    ];
  };
}
