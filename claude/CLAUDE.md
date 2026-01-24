# Global Instructions

## Communication
- 日本語で会話する
- 簡潔に、要点を押さえて回答する
- 不明点は推測せず確認する

## Code Style
- シンプルで読みやすいコードを優先
- 過度な抽象化を避ける
- 既存のコードスタイルに合わせる
- 不要なコメントは書かない（コードで意図を表現する）

## Development Preferences
- テストは実装と一緒に考える
- エラーハンドリングは適切に（過剰にならない程度に）
- セキュリティを意識する（特に入力値の検証、認証周り）
- パフォーマンスは必要になってから最適化

## Git
- コミットメッセージは英語で、簡潔に
- 1コミット = 1つの論理的な変更
- GitHub操作（PR、Issue、リポジトリ情報など）は `gh` CLIを使用する

## Claude Code Settings (dotfiles)
- 共通設定は `~/dotfiles/claude/` に作成し、`~/.config/claude/` へシンボリックリンクを張る
- 直接 `~/.config/claude/` にファイルを作成しない
- 現在シンボリックリンクで管理しているもの:
  - `CLAUDE.md` - グローバル指示
  - `settings.json` - 設定ファイル
  - `hooks/` - フック用スクリプト
  - `skills/` - カスタムスキル
  - `commands/` - カスタムコマンド
  - `agents/` - カスタムエージェント
  - `rules/` - 追加ルール
  - `statusline.sh` - ステータスライン表示
