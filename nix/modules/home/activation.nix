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

  # mise install で config 内の全 tool (node + npm:*) を一気に install
  # 既に install 済みは skip されるので冪等
  # 初回は時間かかる (node + 数個 npm package で数分)
  #
  # PATH に mise を含めて exec しないと、mise が install した node の
  # npm shim が内部で `mise` を呼ぶ際に "command not found" になり
  # reshim が失敗する (packages 自体は install されるが shim が生成されない)
  home.activation.miseInstall = lib.hm.dag.entryAfter [ "miseTrust" ] ''
    if [ -f "$HOME/dotfiles/mise/config.toml" ] && [ -x "${pkgs.mise}/bin/mise" ]; then
      echo "📦 Running mise install..."
      PATH="${pkgs.mise}/bin:$PATH" ${pkgs.mise}/bin/mise install \
        || echo "⚠️ mise install で一部失敗 (手動で 'mise install --verbose' を試す)"
    fi
  '';
}
