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
    in
    {
      darwinConfigurations."macbook-casone" = nix-darwin.lib.darwinSystem {
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

      homeConfigurations."macbook-casone" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
}
