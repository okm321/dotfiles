---
name: resolve-conflict
description: base ブランチ(デフォルト dev)と比較してコンフリクトを検出し、両側の意図を読んだ上で解決する。「コンフリクト解決して」「resolve-conflict」で発火。引数で base を指定可
disable-model-invocation: true
allowed-tools: Bash(git *), Read, Edit, Glob, Grep, AskUserQuestion
---

# Resolve Conflict

コンフリクトは「両側が何をしたかったか」を読んでから直す。機械的にどちらかを採らない。

## 1. 前提チェック

```
git status --short
git branch --show-current
```

- 未コミットの変更があれば止まる(stash も勝手にしない)
- rebase / merge が進行中(`.git/MERGE_HEAD` や `.git/rebase-merge` がある)なら、その続きとして 3 から始める

## 2. base と方法を決める

- base は引数があればそれ、無ければ `dev`(無ければ `develop` → `main`)。AskUserQuestion で確認する
- 方法は同じ質問で聞く: **merge(推奨: 履歴を書き換えない)** / rebase(PR を一直線にしたい時)

```
git fetch origin --prune
git merge-tree --write-tree origin/<base> HEAD
```

`merge-tree` の終了コードが 0 ならコンフリクトなし。「コンフリクトなし。<base> より N コミット先行、M コミット遅れ」と報告して終了(`git rev-list --left-right --count origin/<base>...HEAD`)。

## 3. コンフリクトを起こす

```
git merge origin/<base>        # または git rebase origin/<base>
git diff --name-only --diff-filter=U
```

## 4. ファイルごとに解決する

各ファイルについて:

1. 3 つの版を読む: `git show :1:<file>`(共通祖先) `:2:<file>`(ours) `:3:<file>`(theirs)。rebase 中は ours/theirs が逆になるので注意
2. base 側で何が変わったかを履歴で確認: `git log --oneline -5 origin/<base> -- <file>`
3. 両側の変更を両方残す形で解決する。同じ行を別の目的で変えている場合は、両方の意図が成り立つ書き方を探す
4. 判断できない場合(片方を捨てるしかない、仕様が衝突している)は AskUserQuestion で聞く。推測で決めない
5. `<<<<<<<` `=======` `>>>>>>>` が残っていないことを確認して `git add <file>`

lock ファイル(`pnpm-lock.yaml` `go.sum` 等)は手で直さず、base 側を採ってから再生成コマンドを案内する。

## 5. 仕上げ

```
git merge --continue    # または git rebase --continue
```

- 型チェック / テストのコマンドがリポジトリにあれば(`package.json` の scripts、`Makefile`、`go.mod`)実行して結果を出す
- push はしない。ファイルごとに「何と何が衝突し、どう解決したか」を 1 行ずつ報告する
