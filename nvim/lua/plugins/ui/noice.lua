return {
	"folke/noice.nvim",
	event = { "BufRead", "BufNewFile", "InsertEnter", "CmdlineEnter" },
	module = { "noice" },
	opts = {
		-- add any options here
		messages = {
			enabled = true,
			view = "mini",
			view_error = "mini",
			view_warn = "mini",
			view_history = "messages",
			view_searchi = "mini",
		},
		views = {
			cmdline_popup = {
				position = {
					row = 8,
					col = "50%",
				},
				size = {
					width = 60,
					height = "auto",
				},
				win_options = {
					-- 透過設定時でも背後のバッファ文字を透かさない
					winblend = 0,
				},
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		{
			"MunifTanjim/nui.nvim",
		},
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		{
			"rcarriga/nvim-notify",
			module = { "notify" },
			config = function()
				require("notify").setup()
			end,
		},
	},
}
