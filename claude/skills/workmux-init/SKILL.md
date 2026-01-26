---
name: workmux-init
description: プロジェクトに .workmux.yaml を自動生成
---

# Workmux Init Skill

プロジェクトの言語・構成を検出し、適切な `.workmux.yaml` を生成する。

## Usage
```
/workmux-init
```

## Instructions

### 1. プロジェクト検出

以下のファイルを確認して言語・パッケージマネージャーを特定:

| ファイル | 言語/ツール | post_create |
|----------|-------------|-------------|
| `pnpm-lock.yaml` | pnpm | `pnpm install` |
| `yarn.lock` | yarn | `yarn install` |
| `package-lock.json` | npm | `npm install` |
| `package.json`（lock なし） | npm | `npm install` |
| `Cargo.toml` | Rust | `cargo build` |
| `go.mod` | Go | `go mod download` |
| `pyproject.toml` | Python (uv/poetry) | `uv sync` or `poetry install` |
| `requirements.txt` | Python (pip) | `pip install -r requirements.txt` |
| `Gemfile` | Ruby | `bundle install` |
| `composer.json` | PHP | `composer install` |

### 2. 環境ファイル検出

以下のパターンで .env 系ファイルを検索:
- `.env.example` → `.env` としてコピー
- `.env.sample` → `.env` としてコピー
- `.env.template` → `.env` としてコピー
- `.env.local.example` → `.env.local` としてコピー

### 3. symlink 候補検出

以下があれば symlink 候補として提案:
- `node_modules/` （Node.js プロジェクト）
- `.pnpm-store/` （pnpm プロジェクト）

### 4. .workmux.yaml 生成

検出結果をもとに `.workmux.yaml` を生成:

```yaml
post_create:
  - {検出した install コマンド}

files:
  copy:
    - {.env.example:.env など}
  symlink:
    - {node_modules など、必要に応じて}
```

### 5. .git/info/exclude に追加

`.workmux.yaml` を個人用 gitignore に追加:

```bash
echo ".workmux.yaml" >> .git/info/exclude
```

※ 既に記載されていれば追加しない

### 6. 結果報告

生成した内容と、追加した設定を報告する。
必要に応じて手動で調整するよう案内。
