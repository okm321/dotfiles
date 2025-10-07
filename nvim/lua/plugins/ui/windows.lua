return {
	"anuvyklack/windows.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"anuvyklack/middleclass",
		-- "anuvyklack/animation.nvim",
	},
	config = function()
		vim.o.winwidth = 10
		vim.o.winminwidth = 10
		vim.o.equalalways = false
		-- windows
		local function cmd(command)
			return table.concat({ "<Cmd>", command, "<CR>" })
		end

		vim.keymap.set("n", "<C-w>z", cmd("WindowsMaximize"))
		vim.keymap.set("n", "<C-w>_", cmd("WindowsMaximizeVertically"))
		vim.keymap.set("n", "<C-w>|", cmd("WindowsMaximizeHorizontally"))
		vim.keymap.set("n", "<C-w>=", cmd("WindowsEqualize"))
		require("windows").setup({
			ignore = {
				filetype = {
					"Avante",
					"AvanteSelectedFiles",
					"AvanteInput",
					"trouble",
					"snacks_terminal",
					"neo-tree",
					"sidekick_terminal",
					"codex",
				},
			},
		})

		local calc_layout = require("windows.calculate-layout")
		if not calc_layout._ignore_current_autowidth_patch then
			local original_autowidth = calc_layout.autowidth
			calc_layout.autowidth = function(curwin)
				if curwin and curwin.is_ignored and curwin:is_ignored() then
					return {}
				end
				return original_autowidth(curwin)
			end
			calc_layout._ignore_current_autowidth_patch = true
		end
	end,
}
