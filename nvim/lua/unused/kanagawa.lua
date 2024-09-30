return {
	"rebelot/kanagawa.nvim",
	lazy = false, -- 必要に応じて遅延ロードを設定
	priority = 1000,
	opts = {
		compile = false,
		undercurl = true,
		commentStyle = { italic = true },
		functionStyle = {},
		keywordStyle = { italic = true },
		statementStyle = { bold = true },
		typeStyle = {},
		transparent = true,
		dimInactive = false,
		terminalColors = true,
		colors = {
			palette = {},
			theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
		},
		overrides = function(colors)
			return {}
		end,
		theme = "wave",
		background = {
			dark = "wave",
			light = "lotus",
		},
	},
	config = function(_, opts)
		require("kanagawa").setup(opts)
		vim.cmd("colorscheme kanagawa")
		vim.api.nvim_set_hl(0, "Visual", { bg = "#2f4f4f", fg = "none" }) -- ここで好きな色を指定
	end,
}
