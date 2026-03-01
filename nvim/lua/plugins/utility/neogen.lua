return {
	"danymat/neogen",
	config = true,
	keys = {
		{
			"<leader>nf",
			function()
				require("neogen").generate()
			end,
			desc = "Generate annotation",
		},
		{
			"<leader>nc",
			function()
				require("neogen").generate({ type = "class" })
			end,
			desc = "Generate class annotation",
		},
		{
			"<leader>nt",
			function()
				require("neogen").generate({ type = "type" })
			end,
			desc = "Generate type annotation",
		},
	},
}
