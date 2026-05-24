{ ... }:
{
  imports = [
    ./modules/home/packages.nix
    ./modules/home/symlinks.nix
    ./modules/home/activation.nix
  ];

  home.username = "okm";
  home.homeDirectory = "/Users/okm";
  home.stateVersion = "25.11";

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}
