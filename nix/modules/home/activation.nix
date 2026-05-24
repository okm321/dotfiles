{ config, lib, pkgs, ... }:
{
  # TPM (tmux Plugin Manager) を ~/.tmux/plugins/tpm に自動 clone
  # 既に存在すれば何もしない (冪等)
  home.activation.installTPM = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
      ${pkgs.git}/bin/git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi
  '';

  # mise が dotfiles の config.toml を信頼するように自動 trust
  # (mise v2024+ で未信頼 config を読まないセキュリティ機能の対処)
  home.activation.miseTrust = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -f "$HOME/dotfiles/mise/config.toml" ] && command -v ${pkgs.mise}/bin/mise > /dev/null; then
      ${pkgs.mise}/bin/mise trust "$HOME/dotfiles/mise/config.toml" 2>/dev/null || true
    fi
  '';
}
