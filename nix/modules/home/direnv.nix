{ ... }:
{
  # direnv 本体 + nix-direnv 連携 (.envrc で `use flake` が使える)
  # zsh hook は ~/dotfiles/zsh/direnv.zsh で手動入れてるのでそのまま
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
