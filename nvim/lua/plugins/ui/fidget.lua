return {
	"j-hui/fidget.nvim",
	event = "BufReadPre",
	opts = {
		progress = {
			-- buf_ls は編集のたびに Indexing progress を送ってくるので通知しない
			ignore = { "buf_ls" },
		},
		-- options
		integration = {
			["nvim-tree"] = {
				enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
			},
		},
	},
}
