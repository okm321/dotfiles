{ pkgs, ... }:
{
  users.users.okm = {
    name = "okm";
    home = "/Users/okm";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
