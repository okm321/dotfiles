return {
	"nvim-lualine/lualine.nvim",
	event = { "InsertEnter", "CursorHold", "FocusLost", "BufRead", "BufNewFile" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "nord",
				disabled_filetypes = {
					"dashboard",
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = {
					{
						"filename",
						file_status = true, -- display file status
						path = 0, -- 0 = just filename
					},
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = "", warn = " ", info = " ", hint = "󱠃 " },
					},
					"encoding",
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						file_status = true,
						path = 1, -- 1 = relative path
					},
				},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		})

		vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE", fg = "#ECEFF4" })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE", fg = "#4C566A" })
	end,
	dependencies = { "nvim-tree/nvim-web-devicons" },
}
