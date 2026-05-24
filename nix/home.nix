{ ... }:
{
  imports = [
    ./modules/home/packages.nix
    ./modules/home/symlinks.nix
    ./modules/home/activation.nix
  ];

  home.username = "okamotonaofumi";
  home.homeDirectory = "/Users/okamotonaofumi";
  home.stateVersion = "25.11";

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}
