---
name: update-clis
description: このMacのCLIツール(nix / Homebrew / mise / npm global / ~/.local/bin)の更新有無と既知の脆弱性を調べ、CVE・GHSAがあるものだけを更新対象として提案し、承認後に更新する。
disable-model-invocation: true
allowed-tools: Read, Bash, Grep, WebFetch
---

**Arguments:** `$ARGUMENTS`(ツール名を渡されたらそれだけ調べる。無ければ全経路)

## ルール

- Step 1〜3は読み取り専用。`flake.lock`・設定ファイル・インストール済みツールを変えない
- 状態を変えるコマンドはStep 4の承認後、承認された対象だけに実行する。案を変えたら聞き直す
- 照合できなかったものは「未確認」と書く。推測で「CVEなし」にしない
- アンインストール・cleanup・gc・lockの巻き戻しはしない。commitしない
- `cd`はzoxideの警告が出るので使わない。パスは絶対パスかフラグで渡す
- npmはsafe-chainの関数でラップされている。読み取りは`command npm`で直接呼ぶ
- 作業ファイルはセッションのscratchpadに置く

## Step 1: 調査(インストール済み・現在・最新)

### nix(home-manager / nix-darwin)

現在のバージョン(store pathのname-version):

```sh
nix-store -q --references "$(nix-store -q --references /etc/profiles/per-user/$USER)" | sed 's|^/nix/store/[a-z0-9]*-||'
nix-store -q --references /run/current-system/sw | sed 's|^/nix/store/[a-z0-9]*-||'
```

パッケージのattr名は`~/dotfiles/nix/modules/home/packages.nix`。`~/dotfiles/nix/flake.nix`のoverlayでnixpkgs-unstableから取っているもの(neovim, buf等)と、flake inputのもの(herdr, gh-prism)がある。

lockされたリビジョンとリモートの先頭を比べる(lockは変えない):

```sh
jq -r '.nodes|to_entries[]|select(.value.locked.type=="github")|"\(.key)\t\(.value.original.owner)/\(.value.original.repo)\t\(.value.original.ref // "HEAD")\t\(.value.locked.rev)"' ~/dotfiles/nix/flake.lock
git ls-remote https://github.com/<owner>/<repo> <refs/heads/<ref>かHEAD>
```

revが違うinputだけ、先頭でのバージョンを評価する(attr名は対象に合わせる):

```sh
nix eval --json --impure --expr 'let p = (builtins.getFlake "github:nixos/nixpkgs/<rev>").legacyPackages.${builtins.currentSystem}; in builtins.listToAttrs (map (n: {name=n; value=p.${n}.version or null;}) ["fzf" "jq"])'
```

同じ式で`meta.homepage`と`src.url`も取れる。Step 2で上流を決めるのに使う。

lockのブランチ(nixos-25.11等)より新しいリリースブランチがあるかも見る。あれば「チャネルが古い」と報告に書く(移行は提案だけ):

```sh
git ls-remote https://github.com/nixos/nixpkgs 'refs/heads/nixos-2[0-9].[0-9][0-9]'
```

### Homebrew(nix-homebrew)

tapはflake inputで固定されていて`brew update`は使えない。`brew outdated`はlockしたtapとの比較にしかならない。

```sh
brew list --versions --formula
brew outdated --formula --json=v2
ls /opt/homebrew/Caskroom/<cask>   # CLI系caskのみ(1password-cli, gcloud-cli等)。`brew list --cask`は未trustのtapで失敗する
```

本当の最新(tapの先頭):

```sh
curl -s https://formulae.brew.sh/api/formula/<name>.json | jq -r '.versions.stable, .homepage, .urls.stable.url'
curl -s https://formulae.brew.sh/api/cask/<name>.json | jq -r .version
curl -s https://raw.githubusercontent.com/<owner>/<tap-repo>/HEAD/Formula/<name>.rb | grep -m2 -E '^\s*(version|url) '   # サードパーティtap
```

### mise

`~/dotfiles/mise/config.toml`の管理分。プロジェクトの設定を拾わないようにhomeで見る:

```sh
mise -C ~ outdated --json 2>/dev/null
mise -C ~ ls --current --json 2>/dev/null
```

### npm global(miseのnode配下)

```sh
command npm ls -g --depth=0 --json 2>/dev/null
command npm outdated -g --json 2>/dev/null
```

### ~/.local/bin(curl install系)

```sh
ls -la ~/.local/bin
which -a <tool>
```

symlink先・`which -a`の順で経路を判定する(例: `claude`は`~/.local/share/claude/versions/`を指す。`herdr`はnix profileにもある)。PATH上で先に来るほうを「使われている版」として扱う。現在は`<tool> --version`、最新は上流のrelease(`gh release view -R <owner>/<repo> --json tagName -q .tagName`)か配布元のregistry(claudeは`command npm view @anthropic-ai/claude-code version`)。

## Step 2: CVE照合

上流ごとに使うAPIを選ぶ。複数当てはまれば両方引く。

| 上流 | API |
| --- | --- |
| npm package | OSV `ecosystem: "npm"` |
| Go製 | OSV `ecosystem: "Go"`、nameはmodule path(例: `github.com/cli/cli/v2`) |
| Rust製 | OSV `ecosystem: "crates.io"` |
| Python製 | OSV `ecosystem: "PyPI"` |
| GitHubにrepoがある | `gh api 'repos/<owner>/<repo>/security-advisories?state=published'` |
| C系ライブラリ等(openssl, sqlite, curl…) | NVD `virtualMatchString=cpe:2.3:a:<vendor>:<product>:<version>` |

OSVのHomebrew ecosystemはほぼ空なので使わない。

OSV(仕様: https://google.github.io/osv.dev/post-v1-query/ , https://google.github.io/osv.dev/post-v1-querybatch/ ):

```sh
# 1件
curl -s -d '{"package":{"name":"<name>","ecosystem":"<eco>"},"version":"<ver>"}' https://api.osv.dev/v1/query | jq -c '[.vulns[]?|{id,aliases}]'
# まとめて(結果は入力と同じ順。返るのはidとmodifiedだけ)
curl -s -d @queries.json https://api.osv.dev/v1/querybatch | jq -c '[.results[]|[.vulns[]?.id]]'
# 詳細(CVE番号とfixed version)
curl -s https://api.osv.dev/v1/vulns/<id> | jq -c '{id,aliases,summary,fixed:[.affected[].ranges[]?.events[]?|select(.fixed)|.fixed]}'
```

脆弱性が無いと`{}`が返る。`next_page_token`があれば`page_token`を付けて続きを引く。

GitHub repo advisory(仕様: https://docs.github.com/en/rest/security-advisories/repository-advisories ):

```sh
gh api 'repos/<owner>/<repo>/security-advisories?state=published' --jq '.[]|{ghsa_id,cve_id,summary,v:[.vulnerabilities[]|{range:.vulnerable_version_range,fixed:.patched_versions}]}'
```

`cve_id`がnullのGHSAもある。現在のバージョンが`vulnerable_version_range`に入るかは自分で判定する。

NVD:

```sh
curl -s 'https://services.nvd.nist.gov/rest/json/cves/2.0?virtualMatchString=cpe:2.3:a:openssl:openssl:3.6.2' | jq -c '{totalResults, ids:[.vulnerabilities[].cve.id]}'
```

NVDは別製品の構成条件として載っているだけのCVEも返す。各CVEの`configurations`を見て、本当にそのバージョンが影響範囲かを確かめる。403/429が返ったら間を空けて再試行する。

nixpkgsのパッケージは上流と同じバージョンでもpatchで修正済みのことがある。上の`nix eval`の式で`map toString (p.<attr>.patches or [])`を見て、CVE番号を含むpatchがあれば「patch済みの可能性」と書く。

## Step 3: 提案

表で出す。CVE・GHSAありを上、その下にoutdatedだけのもの、最後に未確認。

| ツール | 経路 | 現在 | 最新 | CVE / GHSA | 推奨 |
| --- | --- | --- | --- | --- | --- |

- 「上げる対象」はCVE・GHSAがあるものだけ。outdatedだけのものは一覧に出すが推奨は「なし」
- 推奨には更新手段と、修正が入る最新版を書く。lock先のチャネルの最新でもまだ影響範囲なら「チャネル内に修正版なし」と書き、手段(nixpkgs-unstableのoverlayに移す、miseに移す等)は提案だけにする
- 同じinputに入っている他のパッケージも一緒に上がる。巻き込まれるものを書く(nixpkgsを上げると全パッケージが動く)

## Step 4: 承認を待つ

承認された行だけを更新する。状態を変えるコマンドはここから先だけ。

| 経路 | 更新 |
| --- | --- |
| nix | `nix flake update <input> --flake ~/dotfiles/nix`のあと、ユーザーに`! cd ~/dotfiles && make switch`を実行してもらう(sudoが要る。`git add -A nix/`も走る) |
| Homebrew | 該当tapのinputを`nix flake update <input> --flake ~/dotfiles/nix` → ユーザーに`! cd ~/dotfiles && make switch` → `brew upgrade <formula>`(`upgrade = false`なのでswitchだけでは上がらない) |
| mise | `mise -C ~ upgrade <tool>` |
| npm global | `command npm i -g <pkg>@<version>` |
| ~/.local/bin | 各ツールのself-update(`claude update`等)。不明なものは公式の手順を確認してから実行する |

## Step 5: 結果報告

- Step 1と同じコマンドでバージョンを再取得し、更新前→更新後を表で出す
- まだ影響範囲のものはStep 2で引き直して残っていると書く
- `git -C ~/dotfiles diff nix/flake.lock`を見せる。commitはしない
