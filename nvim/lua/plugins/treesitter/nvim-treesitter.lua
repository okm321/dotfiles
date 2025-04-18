return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
		-- "windwp/nvim-ts-autotag", -- HTMLタグの自動閉じ
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				-- 主要言語
				"typescript",
				"tsx",
				"javascript",
				"vue",
				"go",
				-- スタイル・マークアップ
				"html",
				"css",
				"scss",
				-- データ形式
				"json",
				"jsonc",
				"yaml",
				"toml",
				"xml",
				-- ドキュメント
				"markdown",
				"markdown_inline",
				"jsdoc",
				-- インフラ関連
				"dockerfile",
				"bash",
				-- 拡張機能（diff表示など）
				"diff",
				"regex",
				"c",
				-- Neovim設定関連
				"lua",
				"luadoc",
				"luap",
				"vim",
				"vimdoc",
				-- ユーティリティ
				"printf",
				"query",
				-- 必要に応じて追加
				"sql",
				"hcl",
				"terraform",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			-- autotag = {
			-- 	enable = true, -- HTMLタグの自動閉じを有効化
			-- },
			-- テキストオブジェクト
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
						["aa"] = "@parameter.outer",
						["ia"] = "@parameter.inner",
					},
				},
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					scope_incremental = "<nop>",
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
