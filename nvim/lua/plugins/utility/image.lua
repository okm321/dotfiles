return {
	"3rd/image.nvim",
	config = function()
		require("image").setup({
			backend = "kitty",
			integrations = {
				markdown = {
					enabled = true,
				},
			},
			max_height_window_percentage = 80,

			-- 画像ファイルを開いた時に自動表示
			hijack_file_patterns = {
				"*.png",
				"*.jpg",
				"*.jpeg",
				"*.gif",
				"*.webp",
				"*.avif",
			},
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "image" },
			callback = function()
				vim.opt_local.fillchars = { eob = " " }
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
			end,
		})
	end,
}
