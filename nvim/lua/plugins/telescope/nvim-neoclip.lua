return {
	"AckslD/nvim-neoclip.lua",
	keys = {
		{ "<leader>nc", "<cmd>Telescope neoclip<cr>" },
	},
	dependencies = {
		{ "nvim-telescope/telescope.nvim" },
	},
	config = function()
		require("neoclip").setup()
	end,
}
