# Security Rules

コードを書く・レビューする際のセキュリティルール。

## Input Validation
- ユーザー入力は常に検証する
- SQLクエリはパラメータ化する
- HTMLに出力する際はエスケープする

## Authentication & Authorization
- パスワードは必ずハッシュ化（bcrypt, argon2）
- JWTは適切な有効期限を設定
- 認可チェックは各エンドポイントで行う

## Secrets Management
- シークレットをコードにハードコードしない
- 環境変数または secrets manager を使用
- .env ファイルは .gitignore に追加

## Dependencies
- 依存パッケージは定期的に更新
- `npm audit`, `pip audit` などでチェック

## Logging
- 機密情報をログに出力しない
- パスワード、トークン、個人情報は除外
