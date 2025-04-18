return {
	"petertriho/nvim-scrollbar",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	-- event = {
	-- 	"BufWinEnter",
	-- 	"CmdwinLeave",
	-- 	"TabEnter",
	-- 	"TermEnter",
	-- 	"TextChanged",
	-- 	"VimResized",
	-- 	"WinEnter",
	-- 	"WinScrolled",
	-- },
	config = function()
		require("scrollbar").setup({
			handle = {
				text = "  ",
				blend = 15,
			},
			marks = {
				Cursor = {
					text = "󰯞 ",
				},
				Search = { text = { " ", " " } },
				Error = { text = { " ", " " } },
				Warn = { text = { " ", " " } },
				Info = { text = { " ", " " } },
				Hint = { text = { " ", " " } },
				Misc = { text = { " ", " " } },
				-- GitAdd = { text = " " },
				-- GitChange = { text = " " },
				-- GitDelete = { text = " " },
			},
			excluded_filetypes = {
				"neo-tree",
				"dashboard",
				"dropbar_menu",
				"snacks_picker_print",
				"snacks_picker_list",
				"snacks_picker_preview",
				"Glance",
				"TelescopePrompt",
				"AvanteInput",
				"Avante",
				"AvanteSelectedFiles",
			},
		})
	end,
}
