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
    # direnv は programs.direnv (modules/home/direnv.nix) で管理するため packages から除外
  ];
}
