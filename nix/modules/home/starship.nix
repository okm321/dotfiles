{ ... }:
{
  # starship 本体のみ Nix 管理
  # ~/.config/starship.toml は symlinks.nix で dotfiles を指してるのでそのまま使う
  # zsh hook は sheldon で eval "$(starship init zsh)" してるので今のまま
  programs.starship.enable = true;
}
