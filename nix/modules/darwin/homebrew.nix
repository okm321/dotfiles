{ ... }:
{
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "uninstall";
    };

    taps = [
      "nikitabobko/tap"
      "osx-cross/avr"
      "raine/workmux"
      "morantron/tmux-fingers"
    ];

    brews = [
      "osx-cross/avr/avr-gcc@9"
      "raine/workmux/workmux"
      "morantron/tmux-fingers/tmux-fingers"
      "ical-buddy"
    ];

    masApps = {
      Xcode = 497799835;
      "Amazon Kindle" = 302584613;
    };

    casks = [
      # ターミナル / ウィンドウ管理 / ランチャー
      "nikitabobko/tap/aerospace"
      "ghostty"
      "raycast"

      # 開発ツール / API
      "http-toolkit"
      "tableplus"
      "postman"
      "orbstack"
      "drawio"

      # エディタ
      "zed"

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
