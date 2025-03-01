return {
	"nvim-telescope/telescope-media-files.nvim",
	dependencies = { "nvim-lua/popup.nvim" },
	config = function()
		require("telescope").setup({
			media_files = {
				-- filetypes whitelist
				-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
				filetypes = { "png", "webp", "jpg", "jpeg" },
				-- find command (defaults to `fd`)
				find_cmd = "rg",
			},
		})
	end,
}
