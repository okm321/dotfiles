return {
	"dnlhc/glance.nvim",
	keys = {
		{ "gd", "<CMD>Glance definitions<CR>", desc = "Glance definitions" },
		{ "gr", "<CMD>Glance references<CR>", desc = "Glance references" },
		{ "gt", "<CMD>Glance type_definitions<CR>", desc = "Glance type definitions" },
		{ "gi", "<CMD>Glance implementations<CR>", desc = "Glance implementations" },
	},
	config = function()
		local glance = require("glance")

		glance.setup({
			height = 20,
			border = {
				enable = true,
				top_char = "─",
				bottom_char = "─",
			},
			theme = {
				enable = true,
				mode = "darken", -- nordはダークなので暗めに寄せる
			},
			folds = {
				fold_closed = "",
				fold_open = "",
				folded = false, -- Automatically fold list on startup
			},
			use_trouble_qf = true,
		})
	end,
}
