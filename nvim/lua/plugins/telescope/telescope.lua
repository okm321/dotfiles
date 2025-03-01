return {
	"nvim-telescope/telescope.nvim",
	keys = {
		{
			"<leader>ff",
			function()
				require("telescope.builtin").find_files()
			end,
			mode = "n",
			desc = "Find files",
		},
		{
			"<leader>fg",
			function()
				require("telescope.builtin").live_grep({
					glob_pattern = "!.git",
				})
			end,
			mode = "n",
			desc = "Grep",
		},
		{
			"<leader>fb",
			"<CMD>Telescope buffers<CR>",
			mode = "n",
			desc = "Find buffers",
		},
		{
			"<leader>fh",
			"<CMD>Telescope help_tags<CR>",
			mode = "n",
			desc = "Find help tags",
		},
		{
			"<leader>gs",
			"<CMD>Telescope git_status<CR>",
			mode = "n",
			desc = "Git status",
		},
		{
			"<leader>gc",
			"<CMD>Telescope git_commits<CR>",
			mode = "n",
			desc = "Git commits",
		},
		{
			"<leader>gb",
			"<CMD>Telescope git_branches<CR>",
			mode = "n",
			desc = "Git branches",
		},
	},
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		}, -- FZF ネイティブ拡張
		"nvim-telescope/telescope-github.nvim",
		{
			"prochri/telescope-all-recent.nvim",
			config = function()
				require("telescope-all-recent").setup({})
			end,
			after = "telescope.nvim",
			dependencies = "kkharji/sqlite.lua",
		},
	},
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
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = {
						"^.git/",
						"^node_modules/",
						-- 他に無視したいパターンがあればここに追加
					},
				},
			},
		})
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("gh")
	end,
}
