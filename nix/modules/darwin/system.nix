{ username, ... }:
{
  system.primaryUser = username;
  system.stateVersion = 6;
  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
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
        "/Applications/Comet.app"
        "/Applications/Zen.app"
        "/Applications/Alacritty.app"
        "/Applications/Ghostty.app"
        "/Applications/CleanShot X.app"
        "/Applications/Slack.app"
        "/Applications/Zed.app"
        "/Applications/Cursor.app"
        "/Applications/cmux.app"
        "/Applications/GatherV2.app"
        "/Applications/Nani.app"
        "/Applications/Claude.app"
        "/System/Applications/App Store.app"
        "/Applications/Amazon Kindle.app"
        "/System/Applications/Books.app"
        "/Applications/OrbStack.app"
        "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app"
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
