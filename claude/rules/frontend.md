---
paths:
  - "**/*.tsx"
  - "**/*.ts"
  - "**/*.css"
  - "**/*.scss"
---

# Frontend Rules

フロントエンド開発時のルール。

## React / Component Design
- コンポーネントは小さく保つ
- 状態は必要な場所で管理（リフトアップは最小限に）
- カスタムフックで ロジックを分離

## Styling
- プロジェクトの既存スタイル手法に従う
- Tailwind, CSS Modules, styled-components など

## Performance
- 大きなリストは仮想化を検討
- 画像は適切なサイズと遅延読み込み
- バンドルサイズを意識

## Accessibility
- セマンティックなHTML要素を使用
- 適切なaria属性
- キーボード操作対応
- 色だけに頼らない情報伝達
