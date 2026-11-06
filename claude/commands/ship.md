---
description: 現在の変更をcommitしてpushするだけのコマンド（PR作成はしない）
allowed-tools: Bash(git add:*), Bash(git commit:*), Bash(git push:*), Bash(git status:*), Bash(git diff:*), Bash(git log:*)
---

現在の変更をcommitしてpushする。PRは作らない。

## Step 1: 変更確認

`git status` と `git diff` で変更内容を確認する。何も変更がなければその旨を報告して終了する。

## Step 2: Stage

論理的な変更単位でstageする。無関係な変更が混ざっている場合は分けてcommitする（1コミット=1つの論理的な変更）。

## Step 3: Commit

日本語で簡潔なコミットメッセージを書く。ユーザーのCLAUDE.md規約（日本語・簡潔・1コミット1変更）に従う。

## Step 4: Push

`git log` でリモート追跡ブランチの有無を確認し、pushする。

- upstreamが未設定なら `git push -u origin HEAD`
- 設定済みなら `git push`

## 注意事項

- force pushは絶対にしない
- 現在のブランチが `main` または `master` の場合は、直接pushする前に警告しユーザーに確認を取る
- commit対象が無ければcommitとpushは行わず、その旨を報告して終了する
