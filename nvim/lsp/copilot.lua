return {
	root_dir = function(bufnr, callback)
		-- 特定の名前を持つファイルでは起動しないようにする
		local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
		local disable_patterns = { "env", "conf", "local", "private" }
		local is_disabled = vim.iter(disable_patterns):any(function(pattern)
			return string.match(fname, pattern)
		end)
		if is_disabled then
			return
		end

		-- git管理下でのみ起動する
		local root_dir = vim.fs.root(bufnr, { ".git" })
		if root_dir then
			return callback(root_dir)
		end
	end,
	on_init = function()
		-- サジェストのハイライト
		local hlc = vim.api.nvim_get_hl(0, { name = "Comment" })
		vim.api.nvim_set_hl(0, "ComplHint", vim.tbl_extend("force", hlc, { underline = true }))
		local hlm = vim.api.nvim_get_hl(0, { name = "MoreMsg" })
		vim.api.nvim_set_hl(0, "ComplHintMore", vim.tbl_extend("force", hlm, { underline = true }))

		-- キーマップの設定 アタッチされたバッファでのみ有効にする
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local bufnr = args.buf

				-- インライン補完を有効に
				vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

				vim.keymap.set("i", "<c-l>", function()
					vim.lsp.inline_completion.get()
					if vim.fn.pumvisible() == 1 then
						return "<c-e>"
					end
				end, { silent = true, expr = true, buffer = bufnr })

				vim.keymap.set("i", "<M-]>", function()
					vim.lsp.inline_completion.select()
					vim.notify("copilot: next suggestion", vim.log.levels.INFO)
				end, { silent = true, buffer = bufnr })
				vim.keymap.set("i", "<M-[>", function()
					vim.lsp.inline_completion.select({ count = -1 * vim.v.count1 })
				end, { silent = true, buffer = bufnr })
			end,
		})
	end,
}
