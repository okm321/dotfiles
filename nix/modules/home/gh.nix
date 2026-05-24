{ inputs, ... }:
{
  # gh-prism (TUI PR レビュー拡張) を programs.gh.extensions に自動登録する module
  imports = [ inputs.gh-prism.homeManagerModules.default ];

  programs.gh = {
    enable = true;
    # gh-prism.enable = true で extensions に自動追加される
  };

  programs.gh-prism.enable = true;
}
