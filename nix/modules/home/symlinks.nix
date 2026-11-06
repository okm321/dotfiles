{ config, lib, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";

  # 複数の Claude Code アカウントで同じ共通設定を共有する。
  # サブアカウントはプロジェクト側の .envrc (dotfiles 管理外) の CLAUDE_CONFIG_DIR で切替
  claudeConfigDirs = [ "claude" "claude-work" ];
  claudeSharedFiles = [
    "CLAUDE.md"
    "settings.json"
    "mcp-servers.json"
    "skills"
    "agents"
    "hooks"
    "commands"
  ];
  claudeSymlinks = builtins.listToAttrs (lib.concatMap (dir:
    map (f: {
      name = "${dir}/${f}";
      value.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/${f}";
    }) claudeSharedFiles
  ) claudeConfigDirs);
in
{
  home.file = {
    # .gitconfig は programs.git が生成するので symlink 不要 (modules/home/git.nix)
    ".aider.conf.yml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/aider/.aider.conf.yml";
    ".aider.model.settings.yml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/aider/.aider.model.settings";
    ".sheldon.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/sheldon/.sheldon.toml";
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/.tmux.conf";
    ".gitmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/.gitmux.conf";
    ".zshrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zsh/.zshrc";
    ".markdownlint-cli2.jsonc".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/markdownlint/.markdownlint-cli2.jsonc";
    ".textlintrc.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/textlint/.textlintrc.json";
  };

  xdg.configFile = {
    "ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ghostty";
    "lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/lazygit";
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
    "starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/starship/starship.toml";
    "aerospace".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/aerospace";
    "yazi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/yazi";
    "zeno".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/zeno";
    "workmux/config.yaml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/workmux/config.yaml";
    "raycast/scripts".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/raycast/scripts";
    "mise/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/mise/config.toml";
    "herdr/config.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/herdr/config.toml";
  } // claudeSymlinks;
}
