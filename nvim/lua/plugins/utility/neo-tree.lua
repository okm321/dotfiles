return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
		"s1n7ax/nvim-window-picker",
	},
	cmd = "Neotree",
	keys = {
		{ "<C-q>", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
		{ "<leader>tj", "<cmd>Neotree focus<cr>", desc = "Focus Neo-tree" },
	},
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
			enable_git_status = true,
			enable_diagnostics = true,
			sources = {
				"filesystem",
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
				use_libuv_file_watcher = false, -- パフォーマンス向上
				filtered_items = {
					visible = false,
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						"node_modules",
					},
					never_show = {
						".git",
						".DS_Store",
					},
				},
			},
			window = {
				width = 30,
				mappings = {
					["<cr>"] = "open",
					["S"] = "open_split",
					["s"] = "",
					["V"] = "open_vsplit",
					["v"] = "",
					["Y"] = function(state)
						local node = state.tree:get_node()
						local filepath = node:get_id()
						local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
						local relative = filepath:sub(#git_root + 2) -- +2 for trailing slash
						vim.fn.setreg("+", relative)
						vim.notify("Copied: " .. relative)
					end,
					-- ファイル名だけコピーしたい場合
					["yn"] = function(state)
						local node = state.tree:get_node()
						local filename = node.name
						vim.fn.setreg("+", filename)
						vim.notify("Copied: " .. filename)
					end,
				},
			},
		})
	end,
}
