return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp", -- LSPソースを補完エンジンに提供
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- 共通の機能設定
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 共通のキーマッピング
		local on_attach = function(client, bufnr)
			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- 定義/参照/実装へのジャンプ
			-- keymap("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
			-- keymap("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
			-- keymap("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
			-- keymap("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

			-- ドキュメント表示とコードアクション
			keymap("n", "K", vim.lsp.buf.hover, opts)
			keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			keymap("n", "gj", vim.lsp.buf.definition, opts)

			-- リネームと診断間の移動
			keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
			keymap("n", "dp", vim.diagnostic.goto_prev, opts)
			keymap("n", "dn", vim.diagnostic.goto_next, opts)

			-- フォーマット
			keymap("n", "<leader>f", function()
				vim.lsp.buf.format({ async = true })
			end, opts)
		end

		-- LSPハンドラーの設定
		local handlers = {
			["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
			["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
		}

		-- 各言語サーバーの設定
		-- TypeScript/JavaScript
		require("lspconfig").ts_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
			root_dir = require("lspconfig/util").root_pattern(".git"),
		})

		-- Vue
		require("lspconfig").volar.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
			filetypes = { "vue" },
		})

		-- Go
		require("lspconfig").gopls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
					gofumpt = true,
				},
			},
		})
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*.go",
			callback = function()
				local params = vim.lsp.util.make_range_params()
				params.context = { only = { "source.organizeImports" } }
				-- buf_request_sync defaults to a 1000ms timeout. Depending on your
				-- machine and codebase, you may want longer. Add an additional
				-- argument after params if you find that you have to write the file
				-- twice for changes to be saved.
				-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
				local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
				for cid, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
							vim.lsp.util.apply_workspace_edit(r.edit, enc)
						end
					end
				end
				vim.lsp.buf.format({ async = false })
			end,
		})

		-- ESLint
		require("lspconfig").eslint.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				-- ESLintでフォーマットする場合
				client.server_capabilities.documentFormattingProvider = true
			end,
			handlers = handlers,
			settings = {
				workingDirectory = { mode = "auto" },
			},
		})

		-- Biome
		require("lspconfig").biome.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- HTML
		require("lspconfig").html.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- CSS
		require("lspconfig").cssls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- css_modules
		require("lspconfig").cssmodules_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- css_variables
		require("lspconfig").css_variables.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- Tailwind CSS
		require("lspconfig").tailwindcss.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- JSON
		require("lspconfig").jsonls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- YAML
		require("lspconfig").yamlls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- TOML
		require("lspconfig").taplo.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- Lua
		require("lspconfig").lua_ls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		-- Terraform
		require("lspconfig").terraformls.setup({
			capabilities = capabilities,
			init_options = {
				terraform = {
					path = "/opt/homebrew/bin/terraform",
				},
			},
			on_attach = function(client, bufnr)
				-- セマンティックトークンを無効化
				client.server_capabilities.semanticTokensProvider = nil
			end,
		})
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.tf", "*.tfvars" },
			callback = function()
				vim.lsp.buf.format()
			end,
		})
		require("lspconfig").tflint.setup({})

		-- Docker
		require("lspconfig").dockerls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
			settings = {
				docker = {
					languageserver = {
						formatter = {
							ignoreMultilineInstructions = true,
						},
					},
				},
			},
		})

		-- Bash
		require("lspconfig").bashls.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- Typos
		require("lspconfig").typos_lsp.setup({
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})

		-- SQL
		require("lspconfig").sqls.setup({
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				on_attach(client, bufnr)
				require("sqls").on_attach(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
			handlers = handlers,
			settings = {
				sqls = {
					connections = {
						{
							driver = "postgresql",
							dataSourceName = "host=127.0.0.1 port=5432 user=postgres password=password dbname=postgres sslmode=disable",
						},
					},
				},
			},
		})

		-- 診断表示の設定
		vim.diagnostic.config({
			underline = true,
			update_in_insert = false,
			virtual_text = {
				spacing = 4,
				prefix = "●",
				source = "if_many",
			},
			severity_sort = true,
			float = {
				border = "rounded",
				source = "always",
			},
		})

		-- 診断アイコンの設定
		local signs = {
			{ name = "DiagnosticSignError", text = "✘" },
			{ name = "DiagnosticSignWarn", text = "▲" },
			{ name = "DiagnosticSignHint", text = "⚑" },
			{ name = "DiagnosticSignInfo", text = "ℹ" },
		}

		for _, sign in ipairs(signs) do
			vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
		end
	end,
}
