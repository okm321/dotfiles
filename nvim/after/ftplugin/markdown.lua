-- Markdown: リスト/箇条書きで改行時に自動継続
--
-- formatoptions:
--   r = insert モードで <CR> を押すとコメント/リスト記号を継続
--   o = normal モードで o/O を押すとコメント/リスト記号を継続
--   n = リストの 2 行目以降を 1 行目の text 開始位置に揃える (autoindent)
vim.opt_local.formatoptions:append("ron")

-- markdown のリスト/引用パターンを comments に登録
-- b:<marker> = blank required after marker (リスト/引用として認識される)
-- チェックボックス系を - より先に書かないと - が優先マッチしてしまう
vim.opt_local.comments = table.concat({
	"b:- [ ]",
	"b:- [x]",
	"b:- [X]",
	"b:-",
	"b:*",
	"b:+",
	"b:>",
}, ",")
