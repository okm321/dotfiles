---
name: figma-check
description: 実装済みの画面・コンポーネントを Figma のデザインと数値で照合し、差分表を出す。`--fix` で修正→再チェックを最大3周。「Figma と合ってるか見て」「figma-check」で発火
argument-hint: "<Figma の node URL> <ローカルの URL または表示手順> [--fix]"
disable-model-invocation: true
allowed-tools: Read, Glob, Grep, Bash(git *), Bash(ls *), Skill, Agent, SendMessage, AskUserQuestion, mcp__plugin_figma_figma__*, mcp__chrome-devtools__*
---

# Figma Check

デザインとのズレは目で見ず数値で出す。直すのは `--fix` を言われたときだけ。

## 0. 前提チェック

- Figma MCP(`get_design_context` を持つサーバー)が接続されているか。無ければ「Figma デスクトップアプリを起動して MCP を有効にしてから」と言って終了
- chrome-devtools MCP が使えるか。無ければ終了
- ローカル URL が応答するか(chrome-devtools で開いて確認)。応答しなければ dev server の起動を案内して終了

引数:

- Figma の node URL(必須)。`node-id` が無い file だけの URL なら node 指定の URL を聞く
- ローカル URL(必須)。`http://localhost:3000/foo` の形。ログインが要る画面なら「表示手順」として文で受ける
- `--fix`(任意)

## 1. Figma 側の値を取る

- `get_design_context` を node に対して呼び、レイアウト・寸法・spacing・タイポグラフィ・色・角丸・ボーダーを読む(呼ぶ前に Skill ツールで `figma:figma-design-to-code` を読むのが MCP 側の前提)
- `get_variable_defs` で変数名(トークン)も取る
- frame の幅を viewport 幅とする(Figma の frame が 390px なら実装も 390px で見る)
- 照合する要素を決める: node の直下〜2階層の主要要素(見出し、本文、ボタン、カード、画像、アイコン)。10個前後に絞る。全要素は見ない

## 2. 実装側の値を取る

- chrome-devtools で viewport を Figma の frame 幅に合わせ、ローカル URL を開く
- 照合する要素ごとに `getComputedStyle` で取る: width / height / padding(4方向) / margin または gap / font-size / font-weight / line-height / letter-spacing / color / background-color / border-radius / border
- スクショを1枚撮る。Figma 側は `get_screenshot` で1枚

## 3. 照合して差分表を出す

判定の閾値:

- 寸法・spacing: ±2px 以内なら OK
- 色: 完全一致(rgb 換算)
- font-size / line-height: ±1px
- font-weight: 完全一致

出力:

- 表は `| 要素 | 項目 | Figma | 実装 | 判定 |`。判定は OK / NG。OK は省略して NG だけ出し、末尾に「照合 N 項目、NG M 件」
- スクショ2枚を見比べ、数値に出ない差(要素の欠落、順序違い、折り返し、アイコン違い)があれば「目視」として別枠で列挙する。目視は推測を含むので「要確認」と書く
- 実装が意図的に Figma と変えている可能性(レスポンシブ対応、既存コンポーネントの流用)は判定せず備考に書く

## 4. `--fix` のとき

- NG の一覧からブリーフを作り、Agent ツール(`model: opus`)に修正させる。ブリーフに含める: 対象ファイル(Grep で当たりを付ける)、各 NG の要素・項目・Figma の値、既存のデザイントークン(`get_variable_defs` の結果と、リポジトリ側の tokens / theme があればそれ)を優先して使うこと、レスポンシブの分岐を壊さないこと、commit しないこと
- 修正後、本流が `git diff` をレビューし、手順 2〜3 を再実行する
- NG が 0 になるか、3周したら止める。3周で残った NG は表にして「手で見るべき差分」として渡す
- `--fix` 無しなら手順 3 で終了

## 注意

- 修正で既存のコンポーネントを別物に置き換えない
- トークンの値を直接書き換えるときは、他の画面に影響するので先に AskUserQuestion で聞く
- Figma の値が変数(トークン)で定義されているのに実装がハードコードなら、値が一致していても「トークン未使用」として備考に出す
- 1周ごとに何を照合して何が NG だったかを短く報告する。ポーリングやスクショの取り直しを繰り返さない
