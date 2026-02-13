# Obsidian Rules

Obsidianへの保存に関するルール。

## 保存先

- Vault: `~/obsidian/`
- 「Obsidianに保存して」と言われたら、このVaultに保存する

## 保存時の手順

1. **保存先ディレクトリを確認する**
   - `~/obsidian/` 内のディレクトリ一覧を取得
   - AskUserQuestionで保存先を選択してもらう

2. **ファイル名**
   - 内容に合った日本語のタイトルをつける
   - スペースは使用OK（Obsidianは対応している）

3. **タグを付ける（frontmatter）**
   - ファイル先頭にYAML frontmatterでタグを付与する
   - 内容に関連するタグを選定する
   - タグは日本語・英語どちらでもOK
   - 例:
     ```yaml
     ---
     tags:
       - Python
       - 自動化
       - CLI
     ---
     ```

## ディレクトリ構成（参考）

- `Tips/` - 技術Tips、設定方法など
- `Research/` - 調査・リサーチ結果
- `Daily/` - 日報・日記
- `Read/` - 読書メモ
