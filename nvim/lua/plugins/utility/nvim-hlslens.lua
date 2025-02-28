return {
	"kevinhwang91/nvim-hlslens",
	keys = {
		{ "n", [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]] },
		{ "N", [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]] },
		{ "*", [[*N<Cmd>lua require('hlslens').start()<CR>]] },
		{ "#", [[#N<Cmd>lua require('hlslens').start()<CR>]] },
		{ "g*", [[g*N<Cmd>lua require('hlslens').start()<CR>]] },
		{ "g#", [[g#N<Cmd>lua require('hlslens').start()<CR>]] },
	},
	config = function()
		require("scrollbar.handlers.search").setup()
	end,
}
