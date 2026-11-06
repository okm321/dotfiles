#!/usr/bin/env bash
set -eu

host="${1:-}"
case "$host" in
work | private) ;;
*)
	echo "usage: $0 <work|private>" >&2
	exit 2
	;;
esac

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES"
echo "$host" >.host

# 素の bash から実行しても brew と brew の git / tmux / mise を見つける
export PATH="/opt/homebrew/bin:$PATH"

if ! command -v brew >/dev/null 2>&1; then
	echo "Homebrew が無いので公式インストーラーで入れます (https://brew.sh)"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if ! command -v brew >/dev/null 2>&1; then
	echo "error: Homebrew を入れた後も /opt/homebrew/bin/brew が見つかりません (Intel Mac は未対応)" >&2
	exit 1
fi

cat Brewfile "hosts/$host/Brewfile" | brew bundle --file=-

status=0

link() {
	local src="$DOTFILES/$1" target="$HOME/$2"
	mkdir -p "$(dirname "$target")"
	if [ -e "$target" ] && [ ! -L "$target" ]; then
		echo "warning: $target は実ファイルかディレクトリなのでスキップ" >&2
		status=1
		return 0
	fi
	ln -sfn "$src" "$target"
}

link sheldon/.sheldon.toml .sheldon.toml
link tmux/.tmux.conf .tmux.conf
link tmux/.gitmux.conf .gitmux.conf
link zsh/.zshrc .zshrc
link zsh/.zshenv .zshenv
link markdownlint/.markdownlint-cli2.jsonc .markdownlint-cli2.jsonc
link textlint/.textlintrc.json .textlintrc.json
link git/.gitconfig .gitconfig
link git/ignore .config/git/ignore
link npm/.npmrc .npmrc

link ghostty .config/ghostty
link lazygit .config/lazygit
link nvim .config/nvim
link starship/starship.toml .config/starship.toml
link aerospace .config/aerospace
link yazi .config/yazi
link zeno .config/zeno
link workmux/config.yaml .config/workmux/config.yaml
link raycast/scripts .config/raycast/scripts
link mise/config.toml .config/mise/config.toml

for f in CLAUDE.md settings.json mcp-servers.json skills agents hooks commands; do
	link "claude/$f" ".claude/$f"
done

# 公開 repo なので commit 前に認証情報と社名を検査する
git -C "$DOTFILES" config core.hooksPath git/hooks
[ -s "$DOTFILES/.deny-words" ] || echo "warning: .deny-words が無いので社名の検査は効きません (1行1つの正規表現で作る)" >&2

mise trust "$DOTFILES/mise/config.toml"
if [ -f "hosts/$host/mise.toml" ]; then
	link "hosts/$host/mise.toml" .config/mise/conf.d/host.toml
	mise trust "$DOTFILES/hosts/$host/mise.toml"
fi
if ! mise install; then
	echo "warning: mise install で一部失敗 (手動で 'mise install --verbose' を試す)" >&2
	status=1
fi
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
# clone だけだと TPM 本体しか入らない。tmux server が無くても内部で起動する
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || true

if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
	if ! gh extension list | grep -q 'kawarimidoll/gh-prism'; then
		gh extension install kawarimidoll/gh-prism || echo "warning: gh-prism の install に失敗" >&2
	fi
else
	echo "gh が未認証です。gh auth login の後で実行: gh extension install kawarimidoll/gh-prism"
fi

cat <<'MANUAL'

残りは手動で実施してください (このスクリプトは実行しません)

1. ログインシェルを Homebrew の zsh に変更
     grep -qx /opt/homebrew/bin/zsh /etc/shells || echo /opt/homebrew/bin/zsh | sudo tee -a /etc/shells
     chsh -s /opt/homebrew/bin/zsh

2. sudo の Touch ID (/etc/pam.d/sudo_local を次の内容にする)
     auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
     auth       sufficient     pam_tid.so

3. macOS の設定
     sh ~/dotfiles/macos/defaults.sh

4. Dock の常駐アプリは手動で並べる

5. 手動で入れるアプリ
     Xcode, Amazon Kindle (App Store)
     Orca (/Applications/Orca.app。cask の orca は別物)
     Dia (/Applications/Dia.app。cask 管理外で入れている)
MANUAL

exit "$status"
