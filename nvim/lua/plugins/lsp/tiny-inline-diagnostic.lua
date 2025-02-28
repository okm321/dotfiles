return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy", -- Or `LspAttach`
	priority = 1000, -- needs to be loaded in first
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "amongus",
			options = {
				show_source = true,
				use_icons_from_diagnostic = false,
				set_arrow_to_diag_color = true,
				multilines = {
					-- Enable multiline diagnostic messages
					enabled = false,

					-- Always show messages on all lines for multiline diagnostics
					always_show = false,
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
			},
		})

		vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
	end,
}
