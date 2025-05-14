return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	filetype = {
		"typescriptreact",
		"typescript",
	},
	config = function()
		require('ts_context_commentstring').setup()
	end
}
