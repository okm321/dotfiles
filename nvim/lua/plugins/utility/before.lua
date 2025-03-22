return {
	"bloznelis/before.nvim",
	keys = {
		{
			"<C-h>",
			function()
				require("before").jump_to_last_edit()
			end,
			mode = "n",
		},
		{
			"<C-l>",
			function()
				require("before").jump_to_next_edit()
			end,
			mode = "n",
		},
		{
			"<leader>oq",
			function()
				require("before").show_edits_in_quickfix()
			end,
			mode = "n",
		},
		-- {
		-- 	"<leader>oe",
		-- 	function()
		-- 		require("before").show_edits_in_telescope()
		-- 	end,
		-- 	mode = "n",
		-- },
	},
	config = function()
		local before = require("before")
		before.setup()
	end,
}
