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
				filetype = { "Avante", "AvanteSelectedFiles", "AvanteInput", "trouble", "snacks_terminal", "neo-tree" },
			},
		})
	end,
}
