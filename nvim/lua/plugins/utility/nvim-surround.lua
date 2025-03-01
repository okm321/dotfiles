return {
	"kylechui/nvim-surround",
	version = "*",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("nvim-surround").setup({})
	end,
}
