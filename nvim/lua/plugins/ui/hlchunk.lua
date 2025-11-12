return {
	"shellRaining/hlchunk.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("hlchunk").setup({
			chunk = {
				enable = true,
				style = "#81A1C1",
				delay = 0,
			},
			indent = {
				enable = true,
			},
			line_num = {
				enable = true,
				style = "#81A1C1",
			},
		})
	end,
}
