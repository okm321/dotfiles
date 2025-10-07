return {
	"williamboman/mason-lspconfig.nvim",
	event = { "BufReadPre" },
	dependencies = {
		{
			"williamboman/mason.nvim",
			cmd = {
				"Mason",
				"MasonInstall",
				"MasonUninstall",
				"MasonUninstallAll",
				"MasonLog",
				"MasonUpdate",
			},
		},
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "williamboman/mason.nvim" },
	},
	opts = {
		ensure_installed = {
			-- TypeScript/JavaScript
			"ts_ls", -- TypeScript
			"eslint", -- ESLint
			"biome", -- Biome
			-- Go
			"gopls", -- Go
			-- HTML/CSS
			"html", -- HTML
			"cssls", -- CSS
			"cssmodules_ls", -- CSS Modules
			"css_variables", -- CSS Variables
			-- 各種設定ファイル
			"jsonls", -- JSON
			"yamlls", -- YAML
			"taplo", -- TOML
			-- SQL
			"sqls", -- SQL
			-- terraform
			"terraformls", -- Terraform
			"tflint", -- TFLint
			-- Docker
			"dockerls", -- Docker
			-- Bash
			"bashls", -- Bash
			-- Neovim設定用
			"lua_ls", -- Lua
			-- タイポ
			"typos_lsp", -- Typos
			-- Markdown LSP
			"marksman", -- Markdown LSP
			"copilot",

			-- リンター
			"eslint_d",
			"biome",

			-- フォーマッター
			"prettierd",
			"stylua",

			-- その他必要なツール
			"markdownlint-cli2",
		},
		automatic_installation = true,
	},
	config = function()
		require("mason").setup()
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- 共通のキーマッピング
		local on_attach = function(client, bufnr)
			local keymap = vim.keymap.set
			local opts = { noremap = true, silent = true, buffer = bufnr }

			-- ドキュメント表示とコードアクション
			keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			keymap("n", "gj", vim.lsp.buf.definition, opts)
			-- vsplitで定義ジャンプ
			vim.keymap.set("n", "gv", function()
				vim.cmd("vsplit")
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "gs", function()
				vim.cmd("split")
				vim.lsp.buf.definition()
			end, opts)

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

		vim.lsp.config("*", {
			capabilities = capabilities,
			on_attach = on_attach,
			handlers = handlers,
		})
	end,
}
