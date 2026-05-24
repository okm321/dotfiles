{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # --- シェル基盤 ---
    zsh
    bash
    starship
    sheldon

    # --- CLI 定番 ---
    bat
    fd
    fzf
    gh
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
    direnv
  ];
}
