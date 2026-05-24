{ config, ... }:
{
  # tmux 本体のみ Nix で管理 (A 案 = ライト)
  # 設定本体とプラグインは現状の dotfiles + TPM をそのまま使う
  # 将来 Step 6-d2: Nix にあるプラグインを programs.tmux.plugins に移行予定
  programs.tmux = {
    enable = true;
    extraConfig = ''
      source-file ${config.home.homeDirectory}/dotfiles/tmux/.tmux.conf
    '';
  };
}
