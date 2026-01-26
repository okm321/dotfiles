---
name: research
description: 技術トピックを調査してドキュメント化
---

# Research Skill

技術トピックの調査を `tech-researcher` エージェントに委譲する。

## Usage
```
/research <トピック> [オプション]
```

## Options
- `--save` または `-s`: Obsidian にファイル出力
- `--output <path>`: 出力先を指定（--save 不要）

## Examples
```
/research React 19                  # 会話内で結果を返す
/research React 19 --save           # ~/obsidian/Research/ に保存
/research React 19 -s               # 同上
/research React 19 --output ./docs  # ./docs に保存
```

## Instructions

### 1. 調査実行
tech-researcher エージェントを使って、指定されたトピックを調査させる。

### 2. 結果表示
調査結果を会話内に表示する。

### 3. 保存確認

**--save / --output 指定時:**
- 確認なしで即座に保存

**オプションなしの場合:**
- 調査結果を表示した後、AskUserQuestion で「Obsidian に保存しますか？」と確認
- 選択肢:
  - 保存する → `~/obsidian/Research/` に保存
  - 保存しない → 終了

### 4. ファイル保存処理
- frontmatter を追加
- ファイル名: `{トピック}_{YYYYMMDD}.md`（スペースはハイフンに）
- 保存後、ファイルパスを報告

### 5. Tips 切り出し確認

Research に保存した後、AskUserQuestion で確認:
「調査内で説明した概念を Tips に切り出しますか？」

- 選択肢:
  - 切り出す → 概念ごとに `~/obsidian/Tips/{概念名}.md` を作成
  - 切り出さない → 終了

**Tips 切り出し時の処理:**
1. 調査内で詳しく説明した基礎概念（例: SSH、VPN、Docker など）を特定
2. 各概念を独立したファイルとして `~/obsidian/Tips/` に作成
3. Research ファイル内に Tips へのリンクを追加（例: `> 詳細は [[SSH]] / [[VPN]] を参照`）
4. Tips ファイル同士も相互リンク

### ファイル保存時の frontmatter

**Research 用:**
```yaml
---
created: {YYYY-MM-DD}
tags: [research, {トピック}]
---
```

**Tips 用:**
```yaml
---
tags: [{関連カテゴリ}]
---
```
※ `tips` タグは不要（フォルダで判別できるため）
