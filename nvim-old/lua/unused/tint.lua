return {
	"levouh/tint.nvim",
	config = function()
		require("tint").setup({
			tint = -50,
			saturation = 1,
		})
	end,
}
