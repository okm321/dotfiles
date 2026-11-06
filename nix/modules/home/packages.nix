{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # --- エージェント多重化 TUI (公式 flake) ---
    inputs.herdr.packages.${pkgs.system}.default

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
    (writeShellScriptBin "gsed" ''exec ${gnused}/bin/sed "$@"'') # homebrew 互換の gsed 名
    htop
    pwgen
    p7zip
    chafa
    tree-sitter
    stylua
    fastfetch
    gitleaks

    # --- メディア・画像処理 ---
    ffmpeg
    imagemagick
    poppler
    graphviz

    # --- 開発系 ---
    mise
    cocoapods
    lua-language-server
    go
    gopls
    buf
    sqlc
    typos-lsp
    httpie
    qsv
    redis
    postgresql # psql 用 (サーバは起動しない)
    pgcli
    mycli

    # --- ネットワーク/インフラ ---
    cloudflared
    tenv # tfenv 後継。terraform 本体は tenv 経由で管理 (nix の terraform と共存すると PATH で衝突するため除外)
    terraform-ls
    tflint
    skaffold
    ssm-session-manager-plugin

    # --- npm tool / LSP (mise の npm:* から Nix 管理に移行) ---
    # npm 系パッケージ同士で内包 typescript が重複するため hiPrio で typescript を優先
    (lib.hiPrio typescript)
    typescript-language-server
    bash-language-server
    yaml-language-server
    vscode-langservers-extracted
    dockerfile-language-server
    # eslint は project の node_modules を使う (system にあると LSP が pnpm の plugin 解決に失敗)
    wrangler
    yarn
    sql-formatter
    vue-language-server
    ni
    prettierd
    biome
    taplo
    stylelint-lsp
    graphql-language-service-cli
    markdownlint-cli2

    gemini-cli     # @google/gemini-cli
    # claude-code / codex は nix 管理外。最新版に追いつかないため公式 native installer or npm global で管理

    # --- Nix 自身の LSP / formatter ---
    nil
    nixpkgs-fmt

    # --- Tap 経由のニッチ系 (Nix にあったもの) ---
    gitmux
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
