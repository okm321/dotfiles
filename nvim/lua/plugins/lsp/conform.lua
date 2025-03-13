-- lua/plugins/lsp/conform.lua
return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufWritePre" },
	keys = {
		{
			"<leader>F", -- <leader>fではなく<leader>Fに変更（LSPとの競合回避）
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "Format buffer",
		},
	},
	config = function()
		local conform = require("conform")

		-- monorepo対応の設定ファイル検索関数
		local function find_config_file(filename, start_dir)
			local current_dir = start_dir or vim.fn.expand("%:p:h")

			-- 現在のディレクトリに設定ファイルがあるか確認
			if vim.fn.filereadable(current_dir .. "/" .. filename) == 1 then
				return current_dir .. "/" .. filename
			end

			-- 親ディレクトリを取得
			local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
			-- 親ディレクトリが現在と同じ場合（ルートに達した場合）は終了
			if parent_dir == current_dir then
				return nil
			end

			-- 再帰的に親ディレクトリを検索（ルートディレクトリの制限を削除）
			return find_config_file(filename, parent_dir)
		end

		conform.setup({
			formatters_by_ft = {
				-- TypeScript/JavaScript
				javascript = { "prettier", "eslint_d", "biome" },
				typescript = { "prettier", "eslint_d", "biome" },
				javascriptreact = { "prettier", "eslint_d", "biome" },
				typescriptreact = { "prettier", "eslint_d", "biome" },
				-- Vue
				vue = { "prettier", "eslint_d" },
				-- スタイル関連
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				-- データフォーマット
				json = { "prettier", "biome" },
				yaml = { "prettier" },
				toml = { "taplo" },
				-- SQL
				sql = { "sql_formatter" }, -- SQL用のフォーマッターを追加
				-- Terraform
				terraform = { "terraform_fmt" },
				-- Docker
				dockerfile = { "dockerfile_fmt" },
				-- Neovim設定
				lua = { "stylua" },
				-- マークダウン
				markdown = { "prettier" },
			},

			-- プロジェクト固有の設定を自動検出（monorepo対応版）
			format_on_save = function(bufnr)
				-- プロジェクトごとに使用するフォーマッタを自動検出
				local function detect_formatters(ft)
					local formatters = {}

					-- Biomeの設定ファイルを探す
					if find_config_file(".biome.json") then
						if ft:match("typescript") or ft:match("javascript") or ft == "json" then
							table.insert(formatters, "biome")
							return formatters
						end
					end

					-- ESLintの設定ファイルを探す
					local eslint_config = find_config_file(".eslintrc.js")
						or find_config_file(".eslintrc.json")
						or find_config_file(".eslintrc.yml")
						or find_config_file(".eslintrc")

					if eslint_config then
						if ft:match("typescript") or ft:match("javascript") or ft == "vue" then
							table.insert(formatters, "eslint_d")

							-- Prettierの設定ファイルを探す
							local prettier_config = find_config_file(".prettierrc")
								or find_config_file(".prettierrc.js")
								or find_config_file(".prettierrc.json")
								or find_config_file(".prettierrc.yaml")
								or find_config_file(".prettierrc.yml")
								or find_config_file(".prettier.config.js")

							if prettier_config then
								table.insert(formatters, "prettier")
							end

							return formatters
						end
					end

					-- デフォルトのフォーマッタを返す
					return conform.formatters_by_ft[ft]
				end

				local ft = vim.bo[bufnr].filetype
				local formatters = detect_formatters(ft)

				if formatters and #formatters > 0 then
					return {
						timeout_ms = 3000, -- タイムアウトを増やす
						lsp_fallback = true,
						formatters = formatters,
					}
				end

				return {
					timeout_ms = 3000,
					lsp_fallback = true,
				}
			end,

			-- 各フォーマッタの詳細設定
			formatters = {
				eslint_d = {
					condition = function()
						return vim.fn.executable("eslint_d") == 1
					end,
					env = {
						-- eslint_dのバッファリングを無効化する環境変数
						ESLINT_D_DISABLE_BUFFERING = "1",
					},
				},
				biome = {
					condition = function()
						return vim.fn.executable("biome") == 1
					end,
					args = { "format", "--write", "--stdin-file-path", "$FILENAME" },
				},
				prettier = {
					-- prettierの設定ファイル探索を深くする
					options = {
						search_parents = true,
					},
				},
				sql_formatter = { -- sql-formatterの設定を追加
					command = "sql-formatter",
					args = { "-l", "postgresql" },
				},
			},
		})

		-- デバッグコマンドの追加
		vim.api.nvim_create_user_command("FormatDebug", function()
			local file = vim.fn.expand("%:p")
			local ft = vim.bo.filetype
			print("Current filetype:", ft)

			if ft:match("javascript") or ft:match("typescript") or ft == "vue" or ft == "json" then
				local biome_path = find_config_file(".biome.json") or "not found"
				local eslint_path = find_config_file(".eslintrc.js")
					or find_config_file(".eslintrc.json")
					or find_config_file(".eslintrc.yml")
					or find_config_file(".eslintrc")
					or "not found"
				local prettier_path = find_config_file(".prettierrc")
					or find_config_file(".prettierrc.js")
					or find_config_file(".prettierrc.json")
					or find_config_file(".prettier.config.js")
					or "not found"

				print("Biome config:", biome_path)
				print("ESLint config:", eslint_path)
				print("Prettier config:", prettier_path)
			end
		end, {})
	end,
}
