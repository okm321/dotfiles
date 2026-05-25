{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- シェル基盤 ---
    zsh
    bash
    # starship は programs.starship (modules/home/starship.nix) で管理
    sheldon

    # --- CLI 定番 ---
    bat
    fd
    fzf
    # gh は programs.gh (modules/home/gh.nix) で管理
    git
    delta
    jq
    lsd
    ripgrep
    tree
    tmux
    neovim
    lazygit
    zoxide
    yazi
    gnused
    htop
    pwgen
    p7zip
    chafa
    tree-sitter
    stylua
    fastfetch

    # --- メディア・画像処理 ---
    ffmpeg
    imagemagick
    poppler
    graphviz

    # --- 開発系 ---
    mise
    lua-language-server
    httpie
    qsv
    redis
    pgcli

    # --- ネットワーク/インフラ ---
    cloudflared
    terraform
    terraform-ls
    tflint
    skaffold

    # --- npm tool / LSP (mise の npm:* から Nix 管理に移行) ---
    # nodePackages 同士で内包 typescript が重複するため hiPrio で typescript を優先
    (lib.hiPrio nodePackages.typescript)
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    nodePackages.vscode-langservers-extracted
    dockerfile-language-server
    nodePackages.eslint
    nodePackages.eslint_d
    nodePackages.wrangler
    nodePackages.yarn
    nodePackages.sql-formatter
    nodePackages."@vue/language-server"
    nodePackages."@antfu/ni"
    nodePackages.vercel
    prettierd
    biome
    taplo
    codex          # @openai/codex
    gemini-cli     # @google/gemini-cli
    claude-code # Anthropic Claude Code (旧 claude-code-bin、merged)

    # --- Nix 自身の LSP / formatter ---
    nil
    nixpkgs-fmt

    # --- Tap 経由のニッチ系 (Nix にあったもの) ---
    gitmux
    mo
    termshot
    qmk
    jankyborders

    # --- その他 ---
    gcalcli
    terminal-notifier
    uv
    bun
    deno # zeno.zsh が依存
    # direnv は programs.direnv (modules/home/direnv.nix) で管理するため packages から除外
  ];
}
