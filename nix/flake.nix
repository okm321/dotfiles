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
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, ... }:
    let
      system = "aarch64-darwin";

      # 特定パッケージを unstable から取るための overlay
      overlays = [
        (final: prev: {
          neovim = nixpkgs-unstable.legacyPackages.${system}.neovim;
        })
      ];

      pkgs = import nixpkgs { inherit system overlays; config.allowUnfree = true; };

      # 全マシン共通の darwinSystem 定義 (DRY)
      # マシン固有設定が必要になったら modules に分岐を入れる
      darwinSystem = nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = overlays; }
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.okamotonaofumi = import ./home.nix;
          }
        ];
      };

      homeConfig = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    in
    {
      darwinConfigurations = {
        "macbook-casone" = darwinSystem; # 現在の会社 Mac
        "macbook-oned" = darwinSystem; # 新 PC 用 (構成は共通)
      };

      homeConfigurations = {
        "macbook-casone" = homeConfig;
        "macbook-oned" = homeConfig;
      };
    };
}
