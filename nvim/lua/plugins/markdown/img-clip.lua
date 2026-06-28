-- HakonHarnes/img-clip.nvim
-- クリップボード画像を md/Markdown ファイルに paste (assets/ 配下保存 + ![]() 挿入)
return {
	"HakonHarnes/img-clip.nvim",
	event = "VeryLazy",
	opts = {
		default = {
			-- 編集中のファイルの同階層に assets/ を掘る
			dir_path = "assets",
			file_name = "%Y-%m-%d-%H-%M-%S",
			use_absolute_path = false,
			relative_to_current_file = true,
			prompt_for_file_name = false,
		},
		filetypes = {
			markdown = {
				url_encode_path = true,
				template = "![$CURSOR]($FILE_PATH)",
			},
		},
	},
	keys = {
		{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard" },
	},
}
