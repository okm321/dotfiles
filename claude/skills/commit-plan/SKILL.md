---
name: commit-plan
description: 未コミットの変更を依存関係の順序で分割コミットする案を出し、承認後に順にコミットする(push はしない)。「分割してコミットして」「commit-plan」で発火
disable-model-invocation: true
allowed-tools: Bash(git *), Read, Glob, Grep, AskUserQuestion
---

# Commit Plan

参照される側を先にコミットする。各コミット時点でビルドが通る単位に切る。

## 1. 状態把握

```
git status --short
git diff --staged
git diff
git ls-files --others --exclude-standard
```

変更が無ければ「未コミットの変更なし」と報告して終了。

## 2. 分割方針を作る

観点:

- **依存関係の順序**: 参照される側を先に。型定義 / スキーマ / migration → 実装 → 呼び出し側 → テスト → 設定・生成物・lock
- 1 コミット = 1 つの論理的変更
- 各コミット時点でビルドが通る単位にする
- 変更が 1 まとまりなら分割せず 1 コミットにする

依頼と無関係に見える差分は分割案に入れず、**除外候補** として別枠で出す:

- 別タスクの残り
- 意図しないフォーマット変更
- すでに staged だった別ファイル

## 3. コミットメッセージを決める

```
git log --oneline -20
```

このリポジトリの直近の型を真似る(接頭辞 `feat:` `fix:` `chore(scope):` の有無、scope の付け方)。日本語で 1 行、簡潔に。

## 4. 承認を取る

AskUserQuestion の preview に次を入れて提示する。

- コミット順(1., 2., ...)
- 各コミットのファイル一覧
- 各コミットのメッセージ
- 除外候補とその理由

選択肢は「この案でコミット」/「修正する」。修正指示があれば反映して再提示する。

## 5. 実行

承認された順に 1 コミットずつ。

```
git add <ファイルを個別指定>
git commit -m "<message>"
```

- `git add -A` `git add .` は使わない
- 除外候補は触らない
- 1 ファイル内で hunk を分けないと切れない場合は `git add -p` を使わず、そのファイルをまとめて 1 コミットに入れ、「分割できなかった」と報告する

## 6. 報告

```
git log --oneline -<n>
```

作ったコミットを見せ、除外候補が残っている旨を 1 行添える。push はしない(`/ship` を案内)。
