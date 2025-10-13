return {
	"Fildo7525/pretty_hover",
	event = "LspAttach",
	opts = {},
	keys = {
		{
			"K",
			function()
				require("pretty_hover").hover()
			end,
			desc = "Hover (Pretty Hover)",
		},
	},
}
