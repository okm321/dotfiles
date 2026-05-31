{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    # homebrew.taps は flake.nix で nix-homebrew.taps から自動同期される
    # (modules には書かない)

    brews = [
      "osx-cross/avr/avr-gcc@9"
      "raine/workmux/workmux"
      "morantron/tmux-fingers/tmux-fingers"
      "k1low/tap/mo"  # Markdown viewer (nixpkgs の mo は別物 = moustache template)
      "ical-buddy"
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
      "tableplus"
      "postman"
      "orbstack"
      "drawio"

      # エディタ
      "zed"
      "visual-studio-code"

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
      "nani"
      "voiceink"

      # Microsoft Office (一括)
      "microsoft-office"

      # フォント
      "font-maple-mono-nf-cn"
    ];
  };
}
