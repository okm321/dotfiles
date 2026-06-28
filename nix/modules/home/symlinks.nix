{ config, ... }:
let
  dotfiles = "${config.home.homeDirectory}/dotfiles";
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

    "claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/CLAUDE.md";
    "claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/settings.json";
    "claude/mcp-servers.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/mcp-servers.json";
    "claude/skills".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/skills";
    "claude/agents".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/agents";
    "claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/rules";
    "claude/hooks".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/hooks";
    "claude/commands".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/commands";
    "claude/statusline.sh".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/statusline.sh";
  };
}
