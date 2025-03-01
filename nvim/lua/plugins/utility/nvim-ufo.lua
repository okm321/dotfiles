return {
	"kevinhwang91/nvim-ufo",
	event = "BufRead",
	dependencies = {
		"kevinhwang91/promise-async",
	},
	config = function()
		-- vim.o.foldcolumn = '1' -- 折りたたみ用の列を表示
		vim.o.foldlevel = 99 -- 初期状態ですべての折りたたみを開く
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
		vim.keymap.set("n", "zp", require("ufo").peekFoldedLinesUnderCursor)

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "neo-tree" },
			callback = function()
				require("ufo").detach()
				vim.opt_local.foldenable = false
			end,
		})
		-- UFOの設定
		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				return { "treesitter", "indent" }
			end,
		})
	end,
}
