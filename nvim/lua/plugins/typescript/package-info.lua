return {
	"vuki656/package-info.nvim",
	event = "BufRead package.json",
	config = function()
		require("package-info").setup()
	end,
	keys = {
		{
			"<leader>ns",
			function()
				require("package-info").show()
			end,
		},
	},
}
