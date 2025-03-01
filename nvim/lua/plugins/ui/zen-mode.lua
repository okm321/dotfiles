return {
	"folke/zen-mode.nvim",
	keys = {
		{
			"<leader>z",
			"<cmd>ZenMode<CR>",
			mode = "n",
		},
	},
	opts = {
		-- your configuration comes here
		-- or leave it empty to use the default settings
		-- refer to the configuration section below
		window = {
			backdrop = 0.8,
			width = 150,
			options = {
				signcolumn = "yes",
			},
		},
	},
}
