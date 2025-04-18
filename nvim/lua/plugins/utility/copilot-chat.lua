return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
			model = "claude-3.7-sonnet-thought",
			agent = "copilot",
		},
		-- See Commands section for default commands if you want to lazy load on them
		-- event = { cmd = { "CopilotChat" } },
	},
}
