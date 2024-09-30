return {
	"kkoomen/vim-doge",
	run = ":call doge#install()",
	config = function()
		-- 設定があればここに追加
		vim.g.doge_enable_mappings = 1
		vim.g.doge_mapping_comment_jump_forward = "<C-j>"
		vim.g.doge_mapping_comment_jump_backward = "<C-k>"
	end,
}
