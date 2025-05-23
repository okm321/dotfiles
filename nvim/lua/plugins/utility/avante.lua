return {
	"yetone/avante.nvim",
	event = "BufReadPost",
	version = false, -- これを "*" に設定しないでください！絶対に！
	opts = {
		-- ここにオプションを追加
		-- 例えば
		provider = "copilot",
		copilot = {
			model = "claude-3.7-sonnet",
		},
		behaviour = {
			auto_apply_diff_after_generation = true,
			enable_cursor_planning_mode = true,
			use_cwd_as_project_root = true,
		},
		file_selector = {
			provider = "telescope",
		},
		windows = {
			width = 20,
			ask = {
				floating = true,
				start_insert = true,
			},
		},
	},
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"zbirenbaum/copilot.lua", -- providers='copilot'の場合
		{
			-- 画像貼り付けのサポート
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- 推奨設定
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- Windowsユーザーに必要
					use_absolute_path = true,
				},
			},
		},
		{
			-- lazy=trueの場合は適切に設定してください
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				-- file_types = { "markdown", "Avante" },
				file_types = { "Avante" },
			},
			ft = { "Avante" },
		},
	},
}
