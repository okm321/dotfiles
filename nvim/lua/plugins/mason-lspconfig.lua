return {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"ts_ls",
				"lua_ls",
				"terraformls",
				"tflint",
				"dockerls",
				"bashls",
				"gopls",
				"html",
				"cssls",
				"css_variables",
				"cssmodules_ls",
				"jsonls",
				"yamlls",
				"taplo",
				"typos_lsp",
				"sqls",
				"biome"
			}, -- 必要なLSPサーバーをインストール
		})
	end,
	after = "mason.nvim",
	dependencies = {
		"williamboman/mason.nvim",
	},
}
