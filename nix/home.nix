{ username, ... }:
{
  imports = [
    ./modules/home/packages.nix
    ./modules/home/symlinks.nix
    ./modules/home/activation.nix
    ./modules/home/git.nix
    ./modules/home/direnv.nix
    ./modules/home/starship.nix
    # ./modules/home/tmux.nix  # ロールバック: programs.tmux のデフォルト設定が競合して tmux server 死亡
  ];

  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "25.11";

  home.sessionVariables = { };

  programs.home-manager.enable = true;
}
