-- tadmccorkle/markdown.nvim
-- Markdown 編集の操作系 (surround / checkbox toggle / heading shift / link / table 整形)
-- 既存の markview.nvim (見た目) / peek.nvim (プレビュー) と役割が直交する
return {
	"tadmccorkle/markdown.nvim",
	ft = { "markdown" },
	opts = {
		-- デフォルトキーマップを有効化 (gs surround, ds delete, cs change, etc.)
		mappings = {
			inline_surround_toggle = "gs",
			inline_surround_toggle_line = "gss",
			inline_surround_delete = "ds",
			inline_surround_change = "cs",
			link_add = "gl",
			link_follow = "gx",
			go_curr_heading = "ghn",
			go_parent_heading = "ghp",
			go_next_heading = "ghj",
			go_prev_heading = "ghk",
		},
		-- ATX 見出し (#) を使う
		inline_surround = {
			emphasis = {
				key = "i",
				txt = "*",
			},
			strong = {
				key = "b",
				txt = "**",
			},
			strikethrough = {
				key = "s",
				txt = "~~",
			},
			code = {
				key = "c",
				txt = "`",
			},
		},
		link = {
			paste = {
				enable = true, -- visual 選択中にリンク貼り付けで [text](url) 化
			},
		},
		toc = {
			-- :MDToc / :MDTocAll で TOC 生成
		},
	},
}
