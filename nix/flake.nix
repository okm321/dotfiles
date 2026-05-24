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
          specialArgs = { inherit username; };
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
                };
              };
            }

            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "backup";
              home-manager.users.${username} = import ./home.nix;
              home-manager.extraSpecialArgs = { inherit username; };
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
        # 現 PC: 既存 /opt/homebrew のため nix-homebrew は disable
        # このマシン廃棄時はこの attribute 全体を削除すれば良い
        "macbook-casone" = mkSystem {
          username = "okamotonaofumi";
          extraModules = [{
            nix-homebrew.enable = nixpkgs.lib.mkForce false;
          }];
        };

        # 新 PC: nix-homebrew で完全管理 (これがデフォルト)
        "macbook-oned" = mkSystem {
          username = "okmkm";
        };
      };

      homeConfigurations = {
        "macbook-casone" = mkHome "okamotonaofumi";
        "macbook-oned" = mkHome "okmkm";
      };
    };
}
