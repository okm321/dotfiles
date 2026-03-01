# CSS Typography Rules

CSS でタイポグラフィを実装する際のルール。主に日本語サイトを対象とする。

参照元: https://gist.github.com/tak-dcxi/0f8b924d6dd81aaeb58dc2e287f2ab3a

## font-family

- 特に指定がなければ `font-family: sans-serif` のみで良い
- `system-ui` は Windows で游ゴシックを呼び出すため**使用禁止**（Tailwind CSS のデフォルトに注意）
- Noto Sans JP を全デバイスで表示する場合は `@font-face` + `local()` で重複読み込みを防ぐ:

```css
@font-face {
  font-family: 'Local Noto Sans JP';
  src: local('Noto Sans JP'), local('Noto Sans CJK JP Regular');
}
:where(:root) {
  font-family: "Local Noto Sans JP", "Noto Sans JP", sans-serif;
}
```

- 明朝体は Android でメーカー削除の可能性があるため Web フォント利用を検討

## テキスト折り返し

- `:root` に以下を指定:

```css
:where(:root) {
  overflow-wrap: anywhere;
  line-break: strict;
}
```

## font-style

- 日本語で斜体は使わない。`<em>` は太字で表現:

```css
:where(em:lang(ja)) { font-weight: bolder; }
:where(:is(address, i, cite, em, dfn):lang(ja)) { font-style: unset; }
```

## text-align

- `text-align: center` は `text-wrap: balance` とセットで指定
- `text-align: justify` は英語混在時に崩れるため**原則禁止**
- 段落の折り返しガタつきは `round()` で全角1文字幅に丸め込む:

```css
.paragraph { inline-size: round(down, 100%, 1ic); }
```

## text-wrap

- 英語見出し: `text-wrap: balance`
- 英語段落: `text-wrap: pretty`
- 日本語: Safari のバグがあるため `text-wrap: pretty` は**現状指定しない**

```css
:where(:is(h1, h2, h3, h4, h5, h6, caption):lang(en)) { text-wrap: balance; }
:where(p:lang(en)) { text-wrap: pretty; }
```

## 文字詰め（font-feature-settings / font-kerning）

- 日本語本文はベタ組みが原則。デフォルトでは文字詰めしない
- 日本語見出しには `font-feature-settings: "palt"` を適用
- 縦書きの場合は `"vpal"` を使用
- カーニング: 英語は `normal`、日本語は `none`、見出しは `normal`

```css
:where(:lang(en)) { font-kerning: normal; }
:where(:lang(ja)) { font-kerning: none; }
:where(h1, h2, h3, h4, h5, h6, caption) {
  font-kerning: normal;
  &:lang(ja) { font-feature-settings: "palt"; }
}
```

## text-autospace

- デフォルトで `text-autospace: normal` を指定
- `<pre>`, `<time>`, `<input>`, `<textarea>`, `[contenteditable]` には `no-autospace`

## text-spacing-trim

- デフォルトで `text-spacing-trim: trim-start` を指定（Chrome のみ）
- `<pre>` には `text-spacing-trim: space-all`

## line-height

- アクセシビリティのため最小 1.5 以上
- 単位なしの number で定義
- 目安: 和文段落 1.7〜2 / 英文段落 1.5〜1.8 / 和文見出し 1.25〜1.5 / 英文見出し 1.2〜1.4
- **`line-height: 1` は指定禁止**。`text-box-trim` で代替する

## text-box-trim / text-box-edge

- ハーフレディング除去に使用。`line-height: 1` の代替手段
- 英文は `text-box-edge: cap alphabetic`、日本語はデフォルトの `text` が適切
- Firefox 未サポートだがプログレッシブ・エンハンスメントで対応

## 文節区切り改行

- 日本語見出しには `word-break: auto-phrase`（Chrome 系のみ）
- `text-wrap: balance` とセットで指定するとより美しい
- **本文への適用は禁止**（可読性悪化）

```css
:where(h1, h2, h3, h4, h5, h6, caption) {
  &:lang(ja) {
    @supports (word-break: auto-phrase) {
      word-break: auto-phrase;
      text-wrap: balance;
    }
  }
}
```

## hanging-punctuation

- 段落に `hanging-punctuation: last allow-end` で行末句読点をぶら下げ（Safari のみ、Chrome 対応予定）
- 英語は `first allow-end last`
- インライン軸の `padding` とセットで指定（はみ出し防止）

## line-clamp

- `overflow: hidden` ではなく `overflow: clip` を使用
  - `hanging-punctuation` との併用時の問題回避
  - Scroll-driven Animation や `position: sticky` を阻害しない

```css
.-line-clamp {
  display: -webkit-box;
  overflow-block: clip;
  -webkit-box-orient: block-axis;
  -webkit-line-clamp: var(--line-clamp--limit, 3);
  @supports not (overflow-block: clip) { overflow-y: clip; }
}
```

## px vs rem

- 基準: 「ユーザーがデフォルトフォントサイズを大きくしたとき、一緒に大きくなるべきか？」
  - `rem`: テキストサイズ、段落の垂直マージン、行間、コンテンツ幅、ブレイクポイント
  - `px`: 装飾的なボーダー幅、細かいデザインディテール、水平方向の padding
- **`:root` に `font-size: 10px` 等の固定値は禁止**（文字拡大機能が無効化される）
- `rem` を使うならブラウザの文字拡大機能で必ず検証する
- ブレイクポイントは `@media (width >= calc(768 / 16 * 1em))` の形式を推奨

## 流体タイポグラフィ

- `clamp()` 関数で最小値〜最大値の範囲でフォントサイズを滑らかに変化
- オンラインジェネレータは避け、Sass の `@function` またはユーティリティクラスで実装
- サイト全体は `svi`、コンポーネントスコープは `cqi` を使い分け

## 手動改行

- `<br>` は使わず CSS で改行制御（`display: inline flow-root` または `display: block flex` + `flex-wrap: wrap`）
- 日本語都合の改行は `:lang(ja)` 限定で適用
- **段落での手動改行はレスポンシブとの相性が悪いため避ける**

## 分離禁止

- 改行で分割されると不都合なワード間には `&zwj;` を挿入

## overflow の使い分け

- 基本は `overflow: clip` を優先使用
- `overflow: hidden` は `grid-template` 系アニメーションなど必要な場合のみ

## リセット CSS

- [kiso.css](https://tak-dcxi.github.io/kiso.css/) の採用を前提とする
- 採用しない場合は kiso.css から該当箇所をコピーして `@layer reset` に配置

## @layer 構成

### base

```css
:where(:lang(en)) { font-kerning: normal; }
:where(:lang(ja)) { font-kerning: none; }
:where(h1, h2, h3, h4, h5, h6, caption) {
  font-kerning: normal;
  &:lang(en) { text-wrap: balance; }
  &:lang(ja) {
    font-feature-settings: "palt";
    @supports (word-break: auto-phrase) {
      word-break: auto-phrase;
      text-wrap: balance;
    }
  }
}
```

### utilities

```css
.-fluid-text { /* clamp() による流体タイポグラフィ */ }
.-text-center { text-align: center; text-wrap: balance; }
.-trim-both { text-box-trim: trim-both; &:lang(en) { text-box-edge: cap alphabetic; } }
.-kerning { font-kerning: normal; &:lang(ja) { font-feature-settings: "palt"; } }
.-auto-phrase { &:lang(ja) { @supports (word-break: auto-phrase) { word-break: auto-phrase; text-wrap: balance; } } }
.-hanging { hanging-punctuation: last allow-end; &:lang(en) { hanging-punctuation: first allow-end last; } }
.-uppercase { text-transform: uppercase; }
.-hyphens { hyphens: auto; }
.-line-clamp { display: -webkit-box; overflow-block: clip; -webkit-box-orient: block-axis; -webkit-line-clamp: var(--line-clamp--limit, 3); }
.-br { display: contents; &:lang(ja) { display: block flow; } }
.-wbr { display: contents; &:lang(ja) { display: inline flow-root; } }
.-tabular-nums { font-variant-numeric: tabular-nums; }
```
