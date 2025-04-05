return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	config = function()
		require("copilot").setup({
			suggestion = {
				auto_trigger = true,
				keymap = {
					accept = "<C-l>",
					-- accept_word = true,
					-- accept_line = true,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-;>",
				},
			},
		})
	end,
}
