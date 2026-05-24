return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"refractalize/oil-git-status.nvim",
		"JezerM/oil-lsp-diagnostics.nvim",
	},
	config = function()
		local detail = false

		require("oil").setup({
			default_file_explorer = true,
			columns = {
				"icon",
			},
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			watch_for_changes = true,
			win_options = {
				signcolumn = "yes:2",
			},
			float = {
				padding = 2,
				max_width = 120,
				max_height = 40,
				border = "rounded",
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name)
					return name == ".git" or name == ".DS_Store"
				end,
			},
			git = {
				add = function() return true end,
				mv = function() return true end,
				rm = function() return true end,
			},
			keymaps = {
				["q"] = { "actions.close", mode = "n" },
				["<C-h>"] = false,
				["<C-s>"] = { "actions.select", opts = { horizontal = true }, desc = "Open in horizontal split" },
				["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open in vertical split" },
				["`"] = {
					callback = function()
						local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
						require("oil").open(root)
					end,
					desc = "Jump to project root",
					mode = "n",
				},
				["gd"] = {
					callback = function()
						detail = not detail
						if detail then
							require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
						else
							require("oil").set_columns({ "icon" })
						end
					end,
					desc = "Toggle file detail view",
					mode = "n",
				},
				["<leader>ff"] = {
					callback = function()
						Snacks.picker.files({ cwd = require("oil").get_current_dir() })
					end,
					desc = "Find files in current directory",
					mode = "n",
				},
				["<leader>fg"] = {
					callback = function()
						Snacks.picker.grep({ cwd = require("oil").get_current_dir() })
					end,
					desc = "Grep in current directory",
					mode = "n",
				},
				["Y"] = {
					callback = function()
						local oil = require("oil")
						local entry = oil.get_cursor_entry()
						if entry then
							local dir = oil.get_current_dir()
							local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
							if git_root and dir then
								local filepath = dir .. entry.name
								local relative = filepath:sub(#git_root + 2)
								vim.fn.setreg("+", relative)
								vim.notify("Copied: " .. relative)
							end
						end
					end,
					desc = "Copy relative path",
					mode = "n",
				},
				["yn"] = {
					callback = function()
						local entry = require("oil").get_cursor_entry()
						if entry then
							vim.fn.setreg("+", entry.name)
							vim.notify("Copied: " .. entry.name)
						end
					end,
					desc = "Copy filename",
					mode = "n",
				},
			},
		})

		require("oil-git-status").setup()
		require("oil-lsp-diagnostics").setup()

		vim.keymap.set("n", "<leader>-", "<cmd>Oil --float<cr>", { desc = "Open Oil (float)" })
	end,
}
