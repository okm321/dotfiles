return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "make",
		}, -- FZF ネイティブ拡張
		"nvim-telescope/telescope-github.nvim",
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
			pickers = {
				find_files = {
					hidden = true,
					file_ignore_patterns = {
						file_ignore_patterns = {
							"^.git/",
							"^node_modules/",
							-- 他に無視したいパターンがあればここに追加
						},
					},
				},
			},
		})
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("gh")

		vim.keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>", {})
		vim.keymap.set("n", "<leader>fg", function()
			require("telescope.builtin").live_grep({
				glob_pattern = "!.git",
			})
		end, {})
		vim.keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>", {})
		vim.keymap.set("n", "<leader>fh", "<CMD>Telescope help_tags<CR>", {})
		vim.keymap.set("n", "<leader>gs", "<CMD>Telescope git_status<CR>", {})
		vim.keymap.set("n", "<leader>gc", "<CMD>Telescope git_commits<CR>", {})
		vim.keymap.set("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", {})
	end,
}
