{ config, ... }:
{
  programs.git = {
    enable = true;

    # Home Manager の新仕様: aliases / extraConfig は settings に統合
    settings = {
      alias = {
        # 現在いるブランチ名を取得して push する
        ps = "!git push origin $(git rev-parse --abbrev-ref @)";
      };

      init.defaultBranch = "main";

      push = {
        default = "current";
        autoSetupRemote = true;
      };

      fetch.prune = true;

      core.pager = "git-split-diffs --color | less -RFX";

      delta = {
        side-by-side = true;
        syntax-theme = "Nord";
        line-numbers = true;
      };

      credential.helper = "store";

      ghq.root = "~/project";
    };

    # 個人情報 (user.name, user.email) は公開 repo に入れないため
    # dotfiles の user.conf を include で読み込む (gitignore 済)
    includes = [
      { path = "${config.home.homeDirectory}/dotfiles/git/user.conf"; }
    ];
  };
}
