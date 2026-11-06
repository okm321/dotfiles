---
name: update-clis
description: このMacのCLIツール(Homebrew / mise / npm global / ~/.local/bin)の更新有無と既知の脆弱性を調べ、CVE・GHSAがあるものだけを更新対象として提案し、承認後に更新する。
disable-model-invocation: true
allowed-tools: Read, Bash, Grep, WebFetch
---

**Arguments:** `$ARGUMENTS`(ツール名を渡されたらそれだけ調べる。無ければ全経路)

## ルール

- Step 1〜3は読み取り専用。設定ファイル・インストール済みツールを変えない
- 例外は`brew update`だけ。Homebrew本体とtap・formulaのmetadataを更新し、必要ならmigrationも走るが、インストール済みのformula・caskと設定ファイルは変えない。これが無いと最新を判定できないので、Step 1の先頭で承認なしに1回だけ実行し、実行したことを報告に書く
- 状態を変えるコマンドはStep 4の承認後、承認された対象だけに実行する。案を変えたら聞き直す
- 照合できなかったものは「未確認」と書く。推測で「CVEなし」にしない
- アンインストール・`brew cleanup`・`mise prune`を自分から実行しない。commitしない
- `brew cat`は使わない(developer modeがオンになり、以後の`brew update`の更新先が変わる)
- `cd`はzoxideの警告が出るので使わない。パスは絶対パスかフラグで渡す
- npmはsafe-chainの関数でラップされている。読み取りは`command npm`で直接呼ぶ
- 作業ファイルはセッションのscratchpadに置く

## Step 1: 調査(インストール済み・現在・最新)

### 経路の判定

どのツールをどの経路が管理しているかは設定ファイルを読んで決める。hostは`~/dotfiles/.host`(`work`か`private`)。

- Homebrew: `~/dotfiles/Brewfile`と`~/dotfiles/hosts/<host>/Brewfile`
- mise: `~/dotfiles/mise/config.toml`と`~/dotfiles/hosts/<host>/mise.toml`(無いhostもある)

Brewfileに無いformulaは依存として入ったものとして扱い、依存元を`brew uses --installed <formula>`で確かめる。同名のツールが複数の経路にあれば`which -a <tool>`で、PATH上で先に来るほうを「使われている版」とする。cask `claude`はデスクトップアプリで、CLIの`claude`は`~/.local/bin`にある。

### Homebrew

`$ARGUMENTS`にHomebrew管理のツールが無ければ`brew update`は省く。失敗したら古いmetadataとの比較になるので、結果を「未確認」扱いにする。

```sh
brew update
brew list --versions --formula
brew list --versions --cask
brew outdated --formula --json=v2
brew outdated --cask --greedy --json=v2
```

- caskはCLI系だけ見る(`1password-cli`, `gcloud-cli`, `session-manager-plugin`等)。`auto_updates`のcaskは`--greedy`を付けないと出ない
- `current_version`がインストール済みより低いことがある(例: `openssl@3`の3.6.2→3.5.9)。`brew upgrade`はこれを下げるので、最新として扱わず報告に書く

Step 2で上流を決めるのに使う(tapのformulaは`<owner>/<tap>/<name>`で引く):

```sh
brew info --json=v2 <formula> | jq -c '.formulae[0]|{full_name,homepage,url:.urls.stable.url,patches}'
brew info --json=v2 --cask <cask> | jq -c '.casks[0]|{token,version,installed,auto_updates,homepage}'
```

### mise

`~/dotfiles/mise/config.toml`と`hosts/<host>/mise.toml`の管理分。プロジェクトの設定を拾わないようにhomeで見る。`npm:`と`github:`のbackendも同じコマンドで出る:

```sh
mise -C ~ outdated --json 2>/dev/null
mise -C ~ outdated --bump 2>/dev/null
mise -C ~ ls --current --json 2>/dev/null
mise -C ~ tool <tool> --backend
```

- ほとんどは`latest`指定で、`mise outdated`は指定の範囲内の最新と比べる
- `npm:typescript`は7系に`tsserver`が無いので、意図してmajor 5に固定している。7系は`--bump`付きの出力にだけ出る。7への移行は、そのことを明記せずに提案しない
- `minimum_release_age`で出たばかりのリリースは除外される。除外されているかは`mise -C ~ upgrade <tool> --dry-run`のWARNで分かる

### npm global(miseのnode配下)

`npm:`のツールはmise管理なのでここには出ない。

```sh
command npm ls -g --depth=0 --json 2>/dev/null
command npm outdated -g --json 2>/dev/null
```

### ~/.local/bin(curl install系)

```sh
ls -la ~/.local/bin
which -a <tool>
```

symlink先・`which -a`の順で経路を判定する(例: `claude`は`~/.local/share/claude/versions/`を指す)。現在は`<tool> --version`、最新は上流のrelease(`gh release view -R <owner>/<repo> --json tagName -q .tagName`)か配布元のregistry(claudeは`command npm view @anthropic-ai/claude-code version`)。registryより現在のほうが新しいことがあるので、その場合はoutdatedにしない。

## Step 2: CVE照合

Homebrewのformulaはまず`brew vulns`で引く。caskは対象外。

```sh
brew vulns --json <formula>
brew vulns --list-skipped
```

- `skipped_formulae`に入ったものと`complete: false`の結果は照合できていない。下の表のAPIで引き直し、引けなければ「未確認」にする
- `complete: true`でも脆弱性が無いことの保証ではない
- `aliases`にCVE・GHSAが無い`OSV-`のIDは「上げる対象」にしない
- `brew outdated --vulnerable`はスキャンできないformulaが1つでもあると止まるので使わない

miseのツールは`mise -C ~ tool <tool> --backend`で上流を決める(`npm:<pkg>`、`aqua:<owner>/<repo>`、`github:<owner>/<repo>`等)。上流ごとに使うAPIを選ぶ。複数当てはまれば両方引く。

| 上流 | API |
| --- | --- |
| npm package | OSV `ecosystem: "npm"` |
| Go製 | OSV `ecosystem: "Go"`、nameはmodule path(例: `github.com/cli/cli/v2`) |
| Rust製 | OSV `ecosystem: "crates.io"` |
| Python製 | OSV `ecosystem: "PyPI"` |
| GitHubにrepoがある | `gh api 'repos/<owner>/<repo>/security-advisories?state=published'` |
| C系ライブラリ等(openssl, sqlite, curl…) | NVD `virtualMatchString=cpe:2.3:a:<vendor>:<product>:<version>` |

OSVのecosystemにHomebrewは指定しない(`openssl`でも空が返る)。

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

Homebrewは基本的に上流のバージョンをそのまま配布するが、formulaに`patches`が付くものもある(Step 1の`brew info`で見える)。上流と同じバージョンでも修正済みと言えるのは、次のどちらかを確認できたときだけ。

- `brew vulns --json`の`patched`に該当のIDがある
- `patches`のURLやファイル名に該当のCVE番号がある。この場合は「patch済みの可能性」と書く

どちらも確認できなければ、影響範囲のまま扱う。

## Step 3: 提案

表で出す。CVE・GHSAありを上、その下にoutdatedだけのもの、最後に未確認。

| ツール | 経路 | 現在 | 最新 | CVE / GHSA | 推奨 |
| --- | --- | --- | --- | --- | --- |

- 「上げる対象」はCVE・GHSAがあるものだけ。outdatedだけのものは一覧に出すが推奨は「なし」
- 推奨には更新手段と、修正が入る最新版を書く。経路の最新でもまだ影響範囲なら「経路内に修正版なし」と書き、手段(miseに移す等)は提案だけにする
- Homebrewのバージョンは固定されていない。`brew upgrade`はformulaの現行版に上げるだけで、版を選べず、rollbackの手段も無い。提案にそう書く
- Homebrewで巻き込まれるものは`HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade --dry-run <formula>`(caskは`--cask`を付ける)で確かめて書く。outdatedなdependentも一緒に上がる。バージョンが下がる行があれば明記する
- miseで修正版が`minimum_release_age`で除外されているなら、その版と除外が切れる日時を書く
- 修正にmajorの変更が要るなら、設定の書き換えが必要だと書く。`mise upgrade --bump`は提案だけにする(引数なしだと全ツールが対象で、`npm:typescript`も7に上がる)

## Step 4: 承認を待つ

承認された行だけを更新する。状態を変えるコマンドはここから先だけ。

| 経路 | 更新 |
| --- | --- |
| Homebrew | `brew upgrade <formula>`、caskは`brew upgrade --cask <cask>` |
| mise | `mise -C ~ upgrade <tool>` |
| npm global | `command npm i -g <pkg>@<version>` |
| ~/.local/bin | 各ツールのself-update(`claude update`等)。不明なものは公式の手順を確認してから実行する |

`brew upgrade`と`mise upgrade`は標準で旧版を消す。`brew upgrade`はそのあと`brew cleanup`を走らせ、`mise upgrade`は旧版を`upgrade.prune_after`の経過後に消す。

## Step 5: 結果報告

- Step 1と同じコマンドでバージョンを再取得し、更新前→更新後を表で出す
- まだ影響範囲のものはStep 2で引き直して残っていると書く
- `git -C ~/dotfiles status --short -- Brewfile hosts mise`を見せ、更新で設定が変わっていないことを確かめる。commitはしない
