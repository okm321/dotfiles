return {
	"Bekaboo/dropbar.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local dropbar_api = require("dropbar.api")
		vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
		vim.api.nvim_set_hl(0, "WinBar", { bg = "NONE", fg = "#D8DEE9" })
		vim.api.nvim_set_hl(0, "WinBarNC", { bg = "NONE", fg = "#D8DEE9" })
	end,
}
