return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({
			server_filetype_map = {
				typescript = "typescript",
			},
			lightbulb = {
				enable = false,
			},
			symbol_in_winbar = {
				folder_level = 2,
			},
			finder = {
				keys = {
					vsplit = "v",
					split = "s",
				},
				methods = {
					tyd = "textDocument/typeDefinition",
				},
			},
			hover = {
				open_link = "gx",
			},
		})
	end,
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons",
	},
}
