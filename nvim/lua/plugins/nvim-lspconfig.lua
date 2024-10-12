return {
	"neovim/nvim-lspconfig",
	after = "mason-lspconfig.nvim",
	opts = {
		servers = {
			marksman = {},
		},
	},
	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- スニペットサポートを有効にする
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		-- tsserverの設定
		lspconfig.ts_ls.setup({
			root_dir = lspconfig.util.root_pattern(".git"),
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				-- キーマッピングの設定
				--[[ local buf_set_keymap = vim.api.nvim_buf_set_keymap
				local opts = { noremap = true, silent = true } ]]
			end,
		})

		-- lua-lsの設定
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
			on_attach = function(client, bufnr)
				-- キーマッピングの設定
				--[[ local buf_set_keymap = vim.api.nvim_buf_set_keymap
				local opts = { noremap = true, silent = true } ]]
			end,
		})

		-- terraformの設定
		lspconfig.terraformls.setup({
			capabilities = capabilities,
			init_options = {
				terraform = {
					path = "/opt/homebrew/bin/terraform",
				},
			},
		})
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.tf", "*.tfvars" },
			callback = function()
				vim.lsp.buf.format()
			end,
		})
		lspconfig.tflint.setup({})

		-- dockerfile
		lspconfig.dockerls.setup({
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

		-- bashls .mkファイルで変にフォーマットが走ったためコメントアウト
		lspconfig.bashls.setup({
			filetypes = { "sh", "bash", "zsh" },
		})

		-- gopls
		lspconfig.gopls.setup({
			capabilities = capabilities,
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

		--html
		lspconfig.html.setup({
			capabilities = capabilities,
		})

		-- css
		lspconfig.cssls.setup({
			capabilities = capabilities,
		})

		-- css_variables
		lspconfig.css_variables.setup({
			capabilities = capabilities,
		})

		-- css_modules
		lspconfig.cssmodules_ls.setup({
			capabilities = capabilities,
		})

		-- jsonls
		lspconfig.jsonls.setup({
			capabilities = capabilities,
		})

		-- yamlls
		lspconfig.yamlls.setup({
			capabilities = capabilities,
		})

		lspconfig.taplo.setup({
			capabilities = capabilities,
		})

		-- typos_lsp
		lspconfig.typos_lsp.setup({
			capabilities = capabilities,
		})
	end,
}
