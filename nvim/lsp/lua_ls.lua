vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			hint = {
				enable = false, -- これでインレイヒント無効化
			},
		},
	},
})
