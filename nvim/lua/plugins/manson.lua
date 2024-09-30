return {
	"williamboman/mason.nvim",
	opts = function()
		require("mason").setup({
			ensure_installed = {
				"markdownlint-cli2",
				"markdown-toc",
			},
		})
	end,
}
