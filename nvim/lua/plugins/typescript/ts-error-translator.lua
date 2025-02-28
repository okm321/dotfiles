return {
	"dmmulroy/ts-error-translator.nvim",
	ft = { "typescript", "typescriptreact" },
	config = function()
		require("ts-error-translator").setup()
	end,
}
