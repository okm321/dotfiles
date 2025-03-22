return {
	"nvim-neotest/neotest",
	event = "BufReadPost",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
	},
	config = function()
		local neotest = require("neotest")

		-- プロジェクトがmonorepoかどうかを判定する関数
		local function is_monorepo()
			return vim.fn.isdirectory(vim.fn.getcwd() .. "/packages") == 1
				or vim.fn.filereadable(vim.fn.getcwd() .. "pnpm-workspace.yaml") == 1
		end

		-- Jest設定ファイルを動的に決定する関数
		local function get_jest_config()
			local file = vim.fn.expand("%:p")
			local is_mono = is_monorepo()
			local config_files = {
				"jest.config.ts",
				"jest.config.js",
			}

			if is_mono then
				-- monorepoの場合の処理
				for _, pkg in ipairs(vim.fn.glob(vim.fn.getcwd() .. "/packages/*", false, true)) do
					local pkg_name = vim.fn.fnamemodify(pkg, ":t")
					if string.find(file, "packages/" .. pkg_name .. "/") then
						-- 各種設定ファイルを探す
						for _, config_name in ipairs(config_files) do
							local pkg_config = pkg .. "/" .. config_name
							if vim.fn.filereadable(pkg_config) == 1 then
								return pkg_config
							end
						end
					end
				end

				-- パッケージ固有の設定がなければルートで探す
				for _, config_name in ipairs(config_files) do
					local root_config = vim.fn.getcwd() .. "/" .. config_name
					if vim.fn.filereadable(root_config) == 1 then
						return root_config
					end
				end

				-- デフォルト（見つからなかった場合）
				return "jest.config.js"
			else
				-- 通常のプロジェクトの場合
				for _, config_name in ipairs(config_files) do
					local config_path = vim.fn.getcwd() .. "/" .. config_name
					if vim.fn.filereadable(config_path) == 1 then
						return config_path
					end
				end

				-- デフォルト
				return "jest.config.js"
			end
		end

		-- 実行コマンドを決定する関数
		local function get_jest_command()
			if is_monorepo() then
				-- monorepoでは通常yarnやnpmスクリプトからパッケージ名を指定して実行
				return "yarn test" -- または："npx jest" など
			else
				-- 通常のプロジェクト
				return "npm test --"
			end
		end

		-- cwdを決定する関数
		local function get_cwd()
			local file = vim.fn.expand("%:p")

			if is_monorepo() then
				-- ファイルが属するパッケージのディレクトリを特定
				for _, pkg in ipairs(vim.fn.glob(vim.fn.getcwd() .. "/packages/*", false, true)) do
					local pkg_name = vim.fn.fnamemodify(pkg, ":t")
					if string.find(file, "packages/" .. pkg_name .. "/") then
						return pkg
					end
				end
			end

			-- デフォルトはプロジェクトルート
			return vim.fn.getcwd()
		end

		neotest.setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = get_jest_command,
					jestConfigFile = get_jest_config,
					cwd = get_cwd,
					env = { CI = true },
				}),
			},
			-- キーマッピングなど他の設定...
		})
	end,
}
