return {
	"m-demare/hlargs.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("hlargs").setup({
			hl_priority = 150,
		})
	end,
}
