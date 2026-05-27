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

    # darwin.nix の homebrew.taps で使う追加 tap (全マシン共通)
    # nix-homebrew で flake.lock に固定 → permission denied 回避
    homebrew-osx-cross-avr = {
      url = "github:osx-cross/homebrew-avr";
      flake = false;
    };
    homebrew-raine-workmux = {
      url = "github:raine/homebrew-workmux";
      flake = false;
    };
    homebrew-morantron-tmux-fingers = {
      url = "github:Morantron/tmux-fingers";
      flake = false;
    };
    homebrew-nikitabobko-tap = {
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };
    homebrew-k1low-tap = {
      url = "github:k1LoW/homebrew-tap";
      flake = false;
    };

    # gh-prism: gh の TUI 拡張 (PR レビュー)
    gh-prism = {
      url = "github:kawarimidoll/gh-prism";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, nix-homebrew, ... }:
    let
      system = "aarch64-darwin";

      overlays = [
        (final: prev: {
          neovim = nixpkgs-unstable.legacyPackages.${system}.neovim;
        })
      ];

      pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };

      # マシン固有 darwinSystem を組み立てる関数
      # username はマシンごとに違うので specialArgs で全 module に渡す
      mkSystem = { username, extraModules ? [] }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = { inherit username inputs; };
          modules = [
            { nixpkgs.overlays = overlays; }
            ./darwin.nix

            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = username;
                mutableTaps = true;
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                  "osx-cross/avr" = inputs.homebrew-osx-cross-avr;
                  "raine/workmux" = inputs.homebrew-raine-workmux;
                  "morantron/tmux-fingers" = inputs.homebrew-morantron-tmux-fingers;
                  "nikitabobko/tap" = inputs.homebrew-nikitabobko-tap;
                  "k1low/tap" = inputs.homebrew-k1low-tap;
                };
              };
            }

            # nix-darwin の homebrew.taps を nix-homebrew.taps と同期
            # これがないと初回 switch で `Refusing to untap homebrew/cask` エラー
            ({ config, ... }: {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            })

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit username inputs; };
            }
          ] ++ extraModules;
        };

      mkHome = username: home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username; };
        modules = [ ./home.nix ];
      };
    in
    {
      darwinConfigurations = {
        "macbook-private" = mkSystem {
          username = "okm";
        };
        "macbook-work" = mkSystem {
          username = "okmkm";
        };
      };

      homeConfigurations = {
        "macbook-private" = mkHome "okm";
        "macbook-work" = mkHome "okmkm";
      };
    };
}
