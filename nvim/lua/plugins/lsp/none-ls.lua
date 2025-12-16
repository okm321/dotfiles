return {
	"nvimtools/none-ls.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local null_ls = require("null-ls")
		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.terraform_fmt,
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.biome.with({
					only_local = "node_modules/.bin",
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
					condition = function(utils)
						return utils.root_has_file({ "biome.json", ".biomerc.json", ".biomerc.yaml", ".biomerc.yml" })
					end,
					args = { "check", ".", "--write", "--stdin-file-path", "$FILENAME" },
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
					condition = function(utils)
						return utils.root_has_file({
							".prettierrc",
							".prettierrc.json",
							".prettierrc.js",
							".prettierrc.cjs",
						})
					end,
				}),
			},
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							-- 同期でフォーマットしてから書き込み、保存後に未保存状態になるのを防ぐ
							vim.lsp.buf.format({ async = false, bufnr = bufnr })
						end,
					})
				end
			end,
		})
	end,
}
