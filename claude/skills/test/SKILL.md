# Test Generation Skill

テストコードを生成するスキル。

## Usage
```
/test [file or function name]
```

## Instructions

1. 対象のコードを読み、テスト対象を特定する
2. 既存のテストファイルがあればそのスタイルに合わせる
3. なければプロジェクトのテストフレームワークを検出する

### テスト設計の方針
- 正常系を最初に
- 境界値テスト
- エラーケース
- モックは最小限に（実際の動作をテストする）

### フレームワーク検出順
1. package.json → jest, vitest, mocha
2. pytest.ini, pyproject.toml → pytest
3. go.mod → go test
4. Cargo.toml → cargo test

## Output

テストコードを生成し、実行コマンドも提示する。
