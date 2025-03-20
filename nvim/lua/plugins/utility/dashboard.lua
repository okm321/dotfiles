local logo = [[
███╗   ██╗ █████╗  ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔══██╗██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║███████║██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║██║  ██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

logo = string.rep("\n", 8) .. logo .. "\n\n"

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			config = {
				header = vim.split(logo, "\n"),
				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },

					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = function()
							Snacks.picker.smart()
						end,
						key = "f",
					},
					{
						desc = "󰗊 Grep",
						group = "DiagnosticHint",
						action = function()
							Snacks.picker.grep()
						end,
						key = "l",
					},
					{
						desc = " LazyGit",
						group = "Number",
						action = "LazyGit",
						key = "g",
					},
				},
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}
