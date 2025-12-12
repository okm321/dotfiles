local util = require("lspconfig.util")

vim.lsp.config("yamlls", {
	root_dir = util.root_pattern(".git", "package.json", ".yamllint"),
	single_file_support = false, -- 単発ファイルでの過剰起動を防ぐ
	settings = {
		yaml = {
			validate = false, -- まずはバリデーションを止めて軽量化
			schemaStore = { enable = false }, -- ネットワーク取得を抑止
			format = { enable = false }, -- フォーマットは null-ls/prettierd 等に任せる
		},
	},
})
