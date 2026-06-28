{ ... }:
{
  # pnpm strict resolution で eslint-config-next 系の plugin (eslint-plugin-react-hooks 等) が
  # 解決できない問題への workaround。lockfile は変えず、ユーザーの node_modules 構造だけ
  # hoist して Node 標準 require が plugin を見つけられるようにする。
  #
  # 根本原因: vscode-eslint-language-server (および ESLint LSP 全般) が
  # eslint-config-next の peerDep として宣言されてない plugin を解決できない。
  # microsoft/vscode-eslint#1986 で OPEN、Next.js v16 の flat config 化で根治済だが
  # v15.x に backport 無し。
  home.file.".npmrc".text = ''
    public-hoist-pattern[]=*eslint-plugin-*
    public-hoist-pattern[]=*eslint-config-*
  '';
}
