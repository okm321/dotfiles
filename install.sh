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

if ! gh auth status >/dev/null 2>&1; then
	gh auth login || echo "warning: gh auth login に失敗。後で gh auth login を実行" >&2
fi
if gh auth status >/dev/null 2>&1 && ! gh extension list | grep -q 'kawarimidoll/gh-prism'; then
	gh extension install kawarimidoll/gh-prism || echo "warning: gh-prism の install に失敗" >&2
fi

# ログインシェルを Homebrew の zsh に
zsh_path=/opt/homebrew/bin/zsh
grep -qx "$zsh_path" /etc/shells || echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
[ "$(dscl . -read "$HOME" UserShell | awk '{print $2}')" = "$zsh_path" ] || chsh -s "$zsh_path"

# sudo の Touch ID。pam_reattach は tmux の中でも効かせるため
pam=/etc/pam.d/sudo_local
pam_body='auth       optional       /opt/homebrew/lib/pam/pam_reattach.so
auth       sufficient     pam_tid.so'
if [ ! -e "$pam" ]; then
	printf '%s\n' "$pam_body" | sudo tee "$pam" >/dev/null
elif [ "$(cat "$pam")" != "$pam_body" ]; then
	echo "warning: $pam が別の内容なので上書きしません。内容を確認してください" >&2
	status=1
fi

sh "$DOTFILES/macos/defaults.sh"

# Claude Code は公式の native installer で入れる (https://code.claude.com/docs/en/setup)
if [ ! -x "$HOME/.local/bin/claude" ]; then
	curl -fsSL https://claude.ai/install.sh | bash
fi

cat <<'MANUAL'

残りは手動で実施してください

1. ログアウトしてログインし直す (macOS の設定とログインシェルの反映)
2. claude を起動してログインし、続けて sh ~/dotfiles/claude/setup.sh
3. 手動で入れるアプリ
     Xcode, Amazon Kindle (App Store)
     Orca, Dia (公式サイト)
MANUAL
if [ "$host" = private ]; then
	echo "     GatherV2 (公式サイト。cask の gather は旧版)"
fi
echo "4. Dock の常駐アプリを並べる"

exit "$status"
