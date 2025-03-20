return {
	"zbirenbaum/copilot.vim",
	lazy = false, -- 挿入モードで読み込む
	event = "InsertEnter",
	config = function()
		-- copilot
		vim.g.copilot_no_tab_map = true
		vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
	end,
}
