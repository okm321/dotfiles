return {
	"j-hui/fidget.nvim",
	event = "BufReadPre",
	opts = {
		-- options
		integration = {
			["nvim-tree"] = {
				enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
			},
		},
	},
}
