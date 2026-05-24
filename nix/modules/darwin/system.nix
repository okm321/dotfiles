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
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
      "com.apple.swipescrolldirection" = false;
      "com.apple.trackpad.scaling" = 2.0;

      ApplePressAndHoldEnabled = false;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      AppleICUForce24HourTime = true;
      _HIHideMenuBar = true;
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
        "/System/Applications/Books.app"
        "/Applications/OrbStack.app"
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
      Clicking = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };
  };
}
