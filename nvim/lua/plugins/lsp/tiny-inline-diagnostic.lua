return {
	"rachartier/tiny-inline-diagnostic.nvim",
	-- event = { "BufReadPost", "BufNewFile" }, -- Or `LspAttach`
	event = { "LspAttach" }, -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "amongus",
			options = {
				show_source = true,
				use_icons_from_diagnostic = false,
				set_arrow_to_diag_color = true,
				add_messages = true,

				multilines = {
					-- Enable multiline diagnostic messages
					enabled = true,

					-- Always show messages on all lines for multiline diagnostics
					always_show = true,
				},
				virt_texts = {
					-- Priority for virtual text display
					priority = 2048,
				},
				signs = {
					left = "",
					right = "",
					diag = "●",
					arrow = "    ",
					up_arrow = "    ",
					vertical = " │",
					vertical_end = " └",
				},
				blend = {
					factor = 0.22,
				},
				overflow = {
					-- Overflow handling mode:
					-- "wrap" - Split long messages into multiple lines
					-- "none" - Do not truncate messages
					-- "oneline" - Keep the message on a single line, even if it's long
					mode = "wrap",

					-- Trigger wrapping this many characters earlier when mode == "wrap"
					-- Increase if the last few characters of wrapped diagnostics are obscured
					padding = 0,
				},
				break_line = {
					-- Enable breaking messages after a specific length
					enabled = true,

					-- Number of characters after which to break the line
					after = 30,
				},
			},
		})
	end,
}
