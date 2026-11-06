---
name: pr-review
description: PR を読む順番に並べたレビューガイドを本流で作り、explain-visually で図解 HTML を開きつつ、バックグラウンドで /code-review high を流す。「PR レビューして」「pr-review」で発火。引数は PR 番号か URL(省略時は現ブランチの PR)
disable-model-invocation: true
allowed-tools: Read, Bash, Glob, Grep, Skill, Write
---

# PR Review

レビュアーが diff を読む前に「どこから読むか」を渡し、精読している間に機械的な指摘を裏で集める。

## 1. 対象 PR を決める

- 引数があればそれ(番号 or URL)
- 無ければ `gh pr view --json number,url -q '.number'`(現ブランチの PR)
- どちらも無ければ「PR が見つからない」と言って終了

## 2. code-review をバックグラウンドで起動する

最初に Skill ツールで `code-review` を `args: "high <PR番号>"` で呼ぶ。
このスキルはバックグラウンド fork として走り、完了すると task-notification で findings が返る。
**待たずに次へ進む。** ポーリングもしない。

## 3. レビューガイドを本流で作る

```
gh pr view <PR> --json title,body,baseRefName,additions,deletions
gh pr diff <PR> --name-only
gh pr diff <PR>
```

diff を読んで、次のフォーマットで出す(日本語)。

```
## <PR タイトル> (#<番号>)
<PR の意図を 1〜2 行。body から。body が空なら diff から推定して「(推定)」を付ける>

## 読む順番
1. `path/to/core.ts` — <変更の意図を 1 行>
2. `path/to/caller.ts` — <1 行>
3. `path/to/types.ts` — <1 行> ※流し読みでOK (rename のみ)
...

## 流し読みでOK
- `a.ts`, `b.ts` — import 整理
- `gen/*.pb.go` — 生成コード
```

順番の決め方:
- 変更の起点(データ構造・型・スキーマ・core ロジック)→ それを使う側 → テスト → 設定/生成物
- 「流し読みでOK」の基準: rename のみ、import 整理、フォーマットのみ、生成コード、lock ファイル、snapshot 更新
- 1 行の意図は「何を」ではなく「なぜ」。diff を見れば分かることは書かない

ガイドを出したら、Skill ツールで `explain-visually` を PR 番号で呼び、図と設計判断カードの解説 HTML をブラウザで開く(全文読み → HTML 生成 → 描画検証 → open は、そのスキルの指示に従う)。カードの識別子(D-01 など)で深掘りできることを伝える。

その後はユーザーの質問に答えつつ findings を待つ。

## 4. findings が届いたら

task-notification で code-review の結果が来たら、読む順番のファイル順に並べ直して出す。

```
## code-review の指摘 (<件数>件)
- `path/to/core.ts:42` — <指摘の要約 1 行>(確信度: 高/中)
```

- 指摘 0 件ならその旨を 1 行
- 指摘の妥当性に疑問があれば、該当箇所を読んで自分の見解を添える
- レビューコメントの投稿は求められるまでしない

## 5. 精読は revdiff で

ユーザーが「revdiff で見る」「diff を開いて」と言ったら Skill ツールで `revdiff` を呼ぶ(引数は PR の baseRefName。PR ブランチはこの worktree にチェックアウト済み)。
基本は revdiff スキルの指示に従うが、PR レビュー文脈での差分:

- code-review の findings が届いていれば、revdiff スキルの「Opening an In-Session Review」の手順で findings を注釈として preload する(diff 上に指摘が重なって見える)
- 戻ってきた注釈のうち code-change directive は **コードに適用しない**。他人の PR なので、レビューコメント案(`path:line` + 本文)にまとめて提示する
- `??` 付きの注釈は質問として、該当コードを読んで答える
- `gh pr review` での投稿は明示的に求められたときだけ
