return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		}, -- FZF ネイティブ拡張
		"nvim-telescope/telescope-frecency.nvim",
	},
	event = "VeryLazy",
	config = function()
		require("telescope").setup({
			defaults = {
				path_display = { "filename_first" },
				vimgrep_arguments = {
					"rg",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
			},
			extensions = {
				file_browser = {
					theme = "ivy",
				},
			},
		})
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("frecency")
		require("telescope").load_extension("gh")
	end,
}
