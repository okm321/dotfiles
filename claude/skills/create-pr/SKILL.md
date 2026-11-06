---
name: create-pr
description: 現在のブランチから PR を作る。このリポジトリでの自分の過去 PR を見てタイトルの形式を踏襲し(本文は空)、ブランチの状態から base ブランチを提案して確認してから作成する。「PR 作って」「create-pr」で発火
disable-model-invocation: true
allowed-tools: Bash(git *), Bash(gh *), Read, Glob, Grep, AskUserQuestion
---

# Create PR

タイトルだけ自分の過去 PR の型を真似る。本文は空。

## 1. 状態確認

```
git status --short
git branch --show-current
git log --oneline -20
```

- 未コミットの変更があれば、その一覧を出して止まる。勝手にコミットしない(`/commit` か `/ship` を案内)
- すでに PR があれば(`gh pr view --json url` が成功)、URL を出して終了

## 2. 過去 PR から形式を抽出する

```
gh pr list --author @me --state all --limit 15 --json number,title,body,baseRefName,headRefName
```

抽出するのは **タイトルの型** だけ: チケット ID の有無と位置、区切り文字、日本語/英語。例: `<TICKET>: <日本語タイトル>` 型なら、現ブランチ名からチケット ID(`[A-Z]+-\d+`)を取って同じ型にする。

**本文は空にする。** 過去 PR の本文形式は真似ない。
例外は `.github/PULL_REQUEST_TEMPLATE.md` がある場合だけで、その時はテンプレートの見出しを残して中身は埋めない(`gh pr create` は `--body` を省略するとテンプレートを自動で使う)。

## 3. base ブランチを提案する

デフォルトは `dev`。次を見て提案を決め、根拠を 1 行添える。

```
git fetch origin --prune
git for-each-ref --format='%(refname:short)' refs/remotes/origin | grep -E 'origin/(dev|develop|main|master|release)'
git merge-base origin/dev HEAD ; git merge-base origin/main HEAD    # 存在する候補だけ
git rev-list --count origin/<候補>..HEAD                             # 候補ごとの先行コミット数
```

判断:
- 現ブランチが分岐した点に最も近い(先行コミット数が最少で、かつ分岐元の履歴を含む)候補を提案
- ブランチ名が `hotfix/` `release/` で始まるなら `main`(`master`)を提案
- 過去 PR の `baseRefName` の多数派も参考にする
- `dev` が存在しなければ `develop` → `main` の順で代替

AskUserQuestion で base を聞く。提案を先頭に「(推奨)」を付け、他の候補も並べる。

## 4. タイトルを出して承認を取る

タイトル、base、push の要否(未 push なら「push して作成」)をまとめて表示し、AskUserQuestion で「作成 / 修正する」を聞く。修正指示があれば反映して再提示。

## 5. 作成

```
git push -u origin <branch>    # 未 push の場合のみ。承認済み
gh pr create --base <base> --title "<title>" --body ""    # テンプレートがある場合は --body を省略
```

URL を出して終了。本文に何も書き足さない(署名も要約も不要)。
