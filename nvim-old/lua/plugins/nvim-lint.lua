return {
	"mfussenegger/nvim-lint",
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			-- javascript = { "biomejs", "eslint_d" },
			-- typescript = { "biomejs", "eslint_d" },
			-- javascriptreact = { "biomejs", "eslint_d" },
			-- typescriptreact = { "biomejs", "eslint_d" },
			-- json = { "biomejs", "eslint_d" },
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			json = { "biomejs" },
			terraform = { "tflint" },
			hcl = { "tflint" },
			markdown = { "markdownlint-cli2" },
			sql = { "sqlfluff" },
		}

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({
			"BufEnter",
			"BufWritePost",
			"InsertLeave",
			"TextChanged",
		}, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
