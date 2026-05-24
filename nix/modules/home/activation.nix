{ config, lib, pkgs, ... }:
{
  # TPM (tmux Plugin Manager) を ~/.tmux/plugins/tpm に自動 clone
  # 既に存在すれば何もしない (冪等)
  home.activation.installTPM = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';
}
