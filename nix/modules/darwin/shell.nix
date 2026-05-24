{ pkgs, ... }:
{
  users.users.okamotonaofumi = {
    name = "okamotonaofumi";
    home = "/Users/okamotonaofumi";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
