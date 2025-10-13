return {
	"ray-x/go.nvim",
	dependencies = { -- optional packages
		"ray-x/guihua.lua",
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("go").setup({
			diagnostic = {
				hdlr = false,
				underline = true,
				update_in_insert = false,
				signs = true,
				-- これを設定しないと、vimのdiagnosticのvirtual_textをfalseにしても、go.nvimが読み込まれる時にtrueに戻されてしまう
				virtual_text = false,
				float = { border = "single" },
			},
		})
	end,
	event = { "CmdlineEnter" },
	ft = { "go", "gomod" },
	build = ':lua require("go.install").update_all_sync()', -- if you need to install/update all binaries
}
