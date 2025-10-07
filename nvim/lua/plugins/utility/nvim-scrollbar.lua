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
		local colors = require("nord.named_colors")
		require("scrollbar").setup({
			handle = {
				text = " ",
				blend = 0,
				priority = 10,
				color = colors.gray,
			},
			marks = {
				Cursor = {
					priority = 0,
					text = "☀",
					color = colors.purple,
				},
				Search = { text = { "✔", "✔" }, color = colors.teal },
				Error = { text = { "✘", "✘" } },
				Warn = { text = { "!", "!" } },
				Info = { text = { "i", "i" } },
				Hint = { text = { "★", "★" } },
				Misc = { text = { " ", " " } },
				GitAdd = {
					text = "█",
					priority = 7,
					gui = nil,
					color = colors.green,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "GitSignsAdd",
				},
				GitChange = {
					text = "█",
					priority = 7,
					gui = nil,
					color = colors.yellow,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "GitSignsChange",
				},
				GitDelete = {
					text = "█",
					priority = 7,
					gui = nil,
					color = colors.red,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "GitSignsDelete",
				},
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
				"snacks_picker_input",
			},
		})
	end,
}
