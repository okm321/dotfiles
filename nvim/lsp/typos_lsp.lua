vim.lsp.config("typos_lsp", {
	init_options = {
		diagnosticSeverity = "warning",
		config = "~/.config/nvim/lsp/config/.typos.toml",
	},
})
