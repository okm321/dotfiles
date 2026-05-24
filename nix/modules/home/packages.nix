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
    terraform-ls
    tflint
    skaffold

    # --- npm tool / LSP (mise の npm:* から Nix 管理に移行) ---
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.bash-language-server
    nodePackages.yaml-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.dockerfile-language-server-nodejs
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
    claude-code-bin # Anthropic Claude Code (prebuilt binary)

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
