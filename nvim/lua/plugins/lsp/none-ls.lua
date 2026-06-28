return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		local helpers = require("null-ls.helpers")
		local methods = require("null-ls.methods")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		-- markdownlint-cli2 の formatter は none-ls の builtin に無いので自前定義。
		-- cli2 は stdin/stdout に対応しないため、to_temp_file で一時ファイル経由で --fix する。
		local markdownlint_cli2_fix = {
			name = "markdownlint_cli2_fix",
			method = methods.internal.FORMATTING,
			filetypes = { "markdown" },
			generator = helpers.formatter_factory({
				command = "markdownlint-cli2",
				args = { "--fix", "$FILENAME" },
				to_temp_file = true,
			}),
		}

		-- textlint: dotfiles/textlint/ にローカル install したルールを使う。
		-- nixpkgs にルール (ja-space-around-code 等) が無いため、ホームの専用ディレクトリで
		-- npm install して node_modules を持つ構成。bin は absolute path で呼び出す。
		-- 初回セットアップ: cd ~/dotfiles/textlint && npm install
		local textlint_cmd = vim.fn.expand("~/dotfiles/textlint/node_modules/.bin/textlint")
		local textlint_fix = {
			name = "textlint_fix",
			method = methods.internal.FORMATTING,
			filetypes = { "markdown" },
			generator = helpers.formatter_factory({
				command = textlint_cmd,
				args = { "--fix", "$FILENAME" },
				to_temp_file = true,
			}),
		}

		-- バッファのパスから上方向に walk して指定ファイルがあるか判定。
		-- null-ls 標準の utils.root_has_file は null-ls の root (≒ cwd) からしか
		-- 探さないため、pnpm monorepo で「サブパッケージ内のファイルを編集中、
		-- ルートに .prettierrc.js がある」状況で検出に失敗する。
		local function has_file_upward(names)
			return vim.fs.find(names, {
				upward = true,
				path = vim.api.nvim_buf_get_name(0),
			})[1] ~= nil
		end

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.diagnostics.markdownlint_cli2,
				markdownlint_cli2_fix,
				null_ls.builtins.diagnostics.textlint.with({
					command = textlint_cmd,
					filetypes = { "markdown" },
				}),
				textlint_fix,
				null_ls.builtins.formatting.biome.with({
					-- only_local = "node_modules/.bin",
					filetypes = {
						"css",
						"scss",
						"html",
						"json",
						"jsonc",
						"yaml",
						"markdown",
						"graphql",
						"typescript",
						"typescriptreact",
						"javascript",
						"javascriptreact",
						"typescript.tsx",
					},
					condition = function()
						-- prettier 設定がある場合は biome 無効
						if
							has_file_upward({
								".prettierrc",
								".prettierrc.json",
								".prettierrc.js",
								".prettierrc.cjs",
								".prettierrc.mjs",
								".prettierrc.yaml",
								".prettierrc.yml",
								"prettier.config.js",
								"prettier.config.cjs",
								"prettier.config.mjs",
							})
						then
							return false
						end
						return has_file_upward({ "biome.json", "biome.jsonc", ".biomerc.json" })
					end,
					args = { "check", "--write", "--stdin-file-path", "$FILENAME" },
				}),
				null_ls.builtins.formatting.prettierd.with({
					prefer_local = "node_modules/.bin",
					filetypes = {
						"css",
						"scss",
						"html",
						"json",
						"jsonc",
						"yaml",
						"markdown",
						"graphql",
						"typescript",
						"typescriptreact",
						"javascript",
						"javascriptreact",
						"typescript.tsx",
					},
					ignore_filetypes = { "biome.json" },
					condition = function()
						-- biome がある場合は prettierd 無効
						if has_file_upward({ "biome.json", "biome.jsonc", ".biomerc.json" }) then
							return false
						end
						return has_file_upward({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.js",
							".prettierrc.cjs",
							".prettierrc.mjs",
							".prettierrc.yaml",
							".prettierrc.yml",
							"prettier.config.js",
							"prettier.config.cjs",
							"prettier.config.mjs",
						})
					end,
				}),
			},
			on_attach = function(client, bufnr)
				-- pcall ガード: nvimtools/none-ls.nvim#276 (Neovim 0.12.2 で
				-- method_to_required_capability_map が nil になる既知バグ) で
				-- on_attach 自体が例外で死んで BufWritePre 登録に到達しないのを防ぐ。
				-- Neovim 0.12 で .supports_method は deprecated、colon 形式に統一。
				local ok, supported = pcall(function()
					return client:supports_method("textDocument/formatting", { bufnr = bufnr })
				end)
				-- 例外時は登録を試みる (format() 実行時にもう一度判定されるので安全)
				if ok and supported == false then
					return
				end

				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						-- 同期でフォーマットしてから書き込み、保存後に未保存状態になるのを防ぐ
						vim.lsp.buf.format({
							async = false,
							bufnr = bufnr,
							filter = function(c)
								return c.name == "null-ls"
							end,
						})
					end,
				})
			end,
		})
	end,
}
