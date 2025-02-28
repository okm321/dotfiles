return {
	"akinsho/bufferline.nvim",
	version = "*",
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		vim.opt.termguicolors = true
		vim.keymap.set("n", "<S-l>", "<Cmd>BufferLineCycleNext<CR>")
		vim.keymap.set("n", "<S-h>", "<Cmd>BufferLineCyclePrev<CR>")
		vim.keymap.set("n", "<leader>th", "<Cmd>BufferLineCloseOthers<CR>")

		require("bufferline").setup({
			options = {
				offsets = {
					{
						filetype = "neo-tree",
						text = "    ",
						separator = true,
					},
				},
			},
		})
	end,
}
