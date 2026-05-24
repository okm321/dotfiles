{
  description = "okm321 dotfiles - Nix + Home Manager + nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";

    # 25.11 stable に無い最新版を取りたいパッケージ用 (現状は neovim 0.12.x)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Homebrew 本体も Nix flake で管理 (default は有効、既存環境マシンのみ disable)
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # tap 群を flake.lock で固定
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, nix-homebrew, ... }:
    let
      system = "aarch64-darwin";

      # 特定パッケージを unstable から取るための overlay
      overlays = [
        (final: prev: {
          neovim = nixpkgs-unstable.legacyPackages.${system}.neovim;
        })
      ];

      pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };

      # 全マシン共通の modules
      # nix-homebrew は default 有効 = 新 PC は 0 から構築可能
      # 既存 Homebrew 環境を持つマシンは個別に disable する
      commonModules = [
        { nixpkgs.overlays = overlays; }
        ./darwin.nix

        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "okamotonaofumi";
            mutableTaps = true;
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
            };
          };
        }

        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.okamotonaofumi = import ./home.nix;
        }
      ];

      homeConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    in
    {
      darwinConfigurations = {
        # 新 PC: nix-homebrew で完全管理 (これがデフォルト)
        "macbook-oned" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = commonModules;
        };

        # 現 PC (macbook-casone): 既存 /opt/homebrew があり autoMigrate が機能しないため
        # nix-homebrew を無効化。このマシンを廃棄する時はこの darwinConfigurations.macbook-casone
        # 全体を削除すれば良い (common に統一される)
        "macbook-casone" = nix-darwin.lib.darwinSystem {
          inherit system;
          modules = commonModules ++ [{
            nix-homebrew.enable = nixpkgs.lib.mkForce false;
          }];
        };
      };

      homeConfigurations = {
        "macbook-casone" = homeConfig;
        "macbook-oned" = homeConfig;
      };
    };
}
