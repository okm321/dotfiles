return {
	"romgrk/barbar.nvim",
	dependencies = { "kyazdani42/nvim-web-devicons", "lewis6991/gitsigns.nvim", "neanias/everforest-nvim" },
	init = function()
		vim.g.barbar_auto_setup = false
	end,
	opts = {
		-- Enables / disables diagnostic symbols
		icons = {
			diagnostics = {
				[vim.diagnostic.severity.ERROR] = { enabled = true, icon = " " },
				[vim.diagnostic.severity.WARN] = { enabled = false },
				[vim.diagnostic.severity.INFO] = { enabled = false },
				[vim.diagnostic.severity.HINT] = { enabled = true },
			},
			gitsigns = {
				added = { enabled = true, icon = " " },
				changed = { enabled = true, icon = "󱚟 " },
				deleted = { enabled = true, icon = " " },
			},
			filetype = {
				-- Sets the icon's highlight group.
				-- If false, will use nvim-web-devicons colors
				custom_colors = false,

				-- Requires `nvim-web-devicons` if `true`
				enabled = true,
			},
		},
		sidebar_filetypes = {
			["neo-tree"] = { event = "BufWipeout", text = "File Explore", align = "center" },
		},
	},
	version = "^1.0.0",
}
