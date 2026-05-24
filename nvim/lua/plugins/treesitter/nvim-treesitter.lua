-- 依存: brew install tree-sitter-cli（パーサーのビルドに必要）
return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			branch = "main",
		},
	},
	init = function()
		-- ハイライトとインデントをビルトイン treesitter で有効化
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
	config = function()
		-- パーサーの自動インストール
		local ensure_installed = {
			"typescript", "tsx", "javascript", "vue", "go",
			"html", "css", "scss",
			"json", "jsonc", "yaml", "toml", "xml",
			"markdown", "markdown_inline", "jsdoc",
			"dockerfile", "bash",
			"diff", "regex",
			"lua", "luadoc", "luap", "vim", "vimdoc",
			"printf", "query",
			"sql", "hcl", "terraform", "c",
		}
		local installed = require("nvim-treesitter.config").get_installed()
		local to_install = vim.iter(ensure_installed)
			:filter(function(p) return not vim.tbl_contains(installed, p) end)
			:totable()
		if #to_install > 0 then
			require("nvim-treesitter").install(to_install)
		end

		-- textobjects: select
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
			},
		})

		local sel = require("nvim-treesitter-textobjects.select").select_textobject
		vim.keymap.set({ "x", "o" }, "af", function() sel("@function.outer", "textobjects") end)
		vim.keymap.set({ "x", "o" }, "if", function() sel("@function.inner", "textobjects") end)
		vim.keymap.set({ "x", "o" }, "ac", function() sel("@class.outer", "textobjects") end)
		vim.keymap.set({ "x", "o" }, "ic", function() sel("@class.inner", "textobjects") end)
		vim.keymap.set({ "x", "o" }, "aa", function() sel("@parameter.outer", "textobjects") end)
		vim.keymap.set({ "x", "o" }, "ia", function() sel("@parameter.inner", "textobjects") end)

		-- textobjects: move
		local move = require("nvim-treesitter-textobjects.move")
		vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@class.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "]A", function() move.goto_next_end("@parameter.inner", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "[C", function() move.goto_previous_end("@class.outer", "textobjects") end)
		vim.keymap.set({ "n", "x", "o" }, "[A", function() move.goto_previous_end("@parameter.inner", "textobjects") end)
	end,
}
