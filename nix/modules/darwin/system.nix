{ username, ... }:
{
  system.primaryUser = username;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];

    # Cachix キャッシュ追加 (prebuilt バイナリで build 時間短縮)
    extra-substituters = [
      "https://kawarimidoll.cachix.org"
    ];
    extra-trusted-public-keys = [
      "kawarimidoll.cachix.org-1:43W5G98mVTyDaMeG7ZGzx4h/be5u4ULUGV/9svLjKJY="
    ];
  };
  nixpkgs.config.allowUnfree = true;

  system.defaults = {
    NSGlobalDomain = {
      AppleShowAllExtensions = true;
      KeyRepeat = 1; # 最速 (画像のスライダー右端)
      InitialKeyRepeat = 15;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.scaling" = 2.0;
      # com.apple.mouse.scaling / scrollwheel.scaling は新 nix-darwin で
      # NSGlobalDomain 直接書き込み不可になったため CustomUserPreferences へ移動

      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      AppleICUForce24HourTime = true;
      _HIHideMenuBar = false;
    };

    dock = {
      autohide = true;
      orientation = "bottom";
      show-recents = false;
      tilesize = 36;
      magnification = false;
      show-process-indicators = true;
      mineffect = "genie";

      mru-spaces = false;
      expose-animation-duration = 0.1;

      # Dock の常駐アプリ (左から右の並び)
      # 存在しないアプリのパスは macOS が無視する
      persistent-apps = [
        "/System/Applications/Apps.app"
        "/System/Applications/Calendar.app"
        "/Applications/Spotify.app"
        "/Applications/Notion.app"
        "/Applications/Google Chrome.app"
        "/Applications/Dia.app"
        "/Applications/Ghostty.app"
        "/Applications/CleanShot X.app"
        "/Applications/Slack.app"
        "/Applications/Zed.app"
        "/Applications/Nani.app"
        "/Applications/Claude.app"
        "/System/Applications/App Store.app"
        "/Applications/OrbStack.app"
        "/Applications/Docker.app"
        "/Applications/Postman.app"
        "/Applications/draw.io.app"
        "/Applications/TablePlus.app"
        "/Applications/Obsidian.app"
        "/Applications/VoiceInk.app"
        "/Applications/Raycast.app"
        "/System/Applications/System Settings.app"
      ];
    };

    finder = {
      ShowPathbar = true;
      FXPreferredViewStyle = "Nlsv";
      _FXSortFoldersFirst = true;

      FXEnableExtensionChangeWarning = false;
      ShowStatusBar = true;
      CreateDesktop = false;
      _FXShowPosixPathInTitle = true;
    };

    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
    };

    trackpad = {
      Clicking = false;  # タップでクリックを無効化 (物理クリックのみ)
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = false;
    };

    # system.defaults.trackpad で書けない詳細設定は CustomUserPreferences で
    CustomUserPreferences = {
      NSGlobalDomain = {
        "com.apple.mouse.scaling" = 2.0;             # マウス軌跡速度
        "com.apple.scrollwheel.scaling" = 0.3125;    # マウススクロール速度
      };

      "com.apple.AppleMultitouchTrackpad" = {
        TrackpadPinch = 1;                       # 拡大/縮小 (2 本指ピンチ)
        TrackpadRotate = 1;                       # 回転 (2 本指)
        TrackpadTwoFingerDoubleTapGesture = 1;    # スマートズーム (2 本指ダブルタップ)
        TrackpadScroll = 1;
        TrackpadMomentumScroll = 1;
        TrackpadHorizScroll = 1;
        TrackpadFourFingerPinchGesture = 2;       # 4 本指ピンチ
        TrackpadFiveFingerPinchGesture = 2;       # 5 本指ピンチ
      };

      # 日本語入力 (ことえり) のライブ変換を無効化
      "com.apple.inputmethod.Kotoeri" = {
        JIMPrefLiveConversionKey = false;
      };
    };
  };
}
