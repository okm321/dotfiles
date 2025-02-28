return {
	"LudoPinelli/comment-box.nvim",
	cmd = { "CBccbox", "CBllline", "CBline" },
	keys = {
		{ "<leader>cb", "<Cmd>CBccbox<CR>", mode = { "n", "v" }, noremap = true, silent = true },
		{ "<leader>ct", "<Cmd>CBllline<CR>", mode = { "n", "v" }, noremap = true, silent = true },
	},
}
