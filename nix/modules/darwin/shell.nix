{ pkgs, username, ... }:
{
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
