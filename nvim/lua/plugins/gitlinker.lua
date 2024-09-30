return {
	"linrongbin16/gitlinker.nvim",
	cmd = "GitLink",
	opts = {},
	keys = {
		{ "<Leader>gy", "<CMD>GitLink<CR>", mode = { "n", "v" }, desc = "Yank git link" },
		{ "<Leader>gY", "<CMD>GitLink!<CR>", mode = { "n", "v" }, desc = "Open git link" },
	},
}
