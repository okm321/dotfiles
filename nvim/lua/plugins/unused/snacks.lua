local logo = [[
███╗   ██╗ █████╗  ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔══██╗██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║███████║██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══██║██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║██║  ██║╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚═╝  ╚═╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
]]

logo = string.rep("\n", 8) .. logo .. "\n\n"

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = {
			enabled = false,
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1 },
				{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = { 2, 2 } },
				{
					pane = 2,
					section = "terminal",
					cmd = "colorscript -e square",
					height = 5,
					padding = 1,
				},
				-- { section = "keys", gap = 1, padding = 1 },
				{
					pane = 2,
					icon = " ",
					desc = "Browse Repo",
					padding = 1,
					key = "b",
					action = function()
						Snacks.gitbrowse()
					end,
				},
				function()
					local in_git = Snacks.git.get_root() ~= nil
					local cmds = {
						{
							title = "Notifications",
							cmd = "gh notify -s -a -n5",
							action = function()
								vim.ui.open("https://github.com/notifications")
							end,
							key = "n",
							icon = " ",
							height = 5,
							enabled = true,
						},
						-- {
						-- 	title = "Open Issues",
						-- 	cmd = "gh issue list -L 3",
						-- 	key = "i",
						-- 	action = function()
						-- 		vim.fn.jobstart("gh issue list --web", { detach = true })
						-- 	end,
						-- 	icon = " ",
						-- 	height = 7,
						-- },
						{
							icon = " ",
							title = "Open PRs",
							cmd = "gh pr list -L 5",
							key = "P",
							action = function()
								vim.fn.jobstart("gh pr list --web", { detach = true })
							end,
							height = 7,
						},
						{
							icon = " ",
							title = "Git Status",
							cmd = "git --no-pager diff --stat -B -M -C",
							height = 10,
						},
					}
					return vim.tbl_map(function(cmd)
						return vim.tbl_extend("force", {
							pane = 2,
							section = "terminal",
							enabled = in_git,
							padding = 1,
							ttl = 5 * 60,
							indent = 3,
						}, cmd)
					end, cmds)
				end,
				{ section = "startup" },
			},
		},
		picker = {
			enabled = true,
			sources = {
				files = {
					hidden = true,
					ignored = true,
					file_ignore_patterns = {
						"^.git/",
						"^node_modules/",
						-- 他に無視したいパターンがあればここに追加
					},
					hide_by_name = {
						"node_modules",
					},
					hide_by_pattern = { -- uses glob style patterns
						--"*.meta",
						--"*/src/*/tsconfig.json",
					},
					always_show = { -- remains visible even if other settings would normally hide it
						".gitignored",
					},
					always_show_by_pattern = { -- uses glob style patterns
						".env*",
					},
					never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
						".DS_Store",
						"thumbs.db",
					},
					never_show_by_pattern = { -- uses glob style patterns
						--".null-ls_*",
					},
				},
			},
			formatters = {
				file = {
					filename_first = true,
					truncate = 70,
				},
			},
		},
		scroll = { enabled = false },
	},
	keys = {
		-- Top Pickers & Explorer
		{
			"<leader>fg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>fb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>ff",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		-- {
		-- 	"<leader>fg",
		-- 	function()
		-- 		Snacks.picker.git_files()
		-- 	end,
		-- 	desc = "Find Git Files",
		-- },
		{
			"<leader>fp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>fr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		-- git
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gS",
			function()
				Snacks.picker.git_stash()
			end,
			desc = "Git Stash",
		},
		{
			"<leader>gd",
			function()
				Snacks.picker.git_diff()
			end,
			desc = "Git Diff (Hunks)",
		},
		-- Grep
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Visual selection or word",
			mode = { "n", "x" },
		},
		-- search
		{
			"<leader>s/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>sC",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		-- LSP
		-- {
		-- 	"gd",
		-- 	function()
		-- 		Snacks.picker.lsp_definitions()
		-- 	end,
		-- 	desc = "Goto Definition",
		-- },
		-- {
		-- 	"gD",
		-- 	function()
		-- 		Snacks.picker.lsp_declarations()
		-- 	end,
		-- 	desc = "Goto Declaration",
		-- },
		-- {
		-- 	"gr",
		-- 	function()
		-- 		Snacks.picker.lsp_references()
		-- 	end,
		-- 	nowait = true,
		-- 	desc = "References",
		-- },
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		-- {
		-- 	"gy",
		-- 	function()
		-- 		Snacks.picker.lsp_type_definitions()
		-- 	end,
		-- 	desc = "Goto T[y]pe Definition",
		-- },
		-- {
		-- 	"<leader>ss",
		-- 	function()
		-- 		Snacks.picker.lsp_symbols()
		-- 	end,
		-- 	desc = "LSP Symbols",
		-- },
		-- {
		-- 	"<leader>sS",
		-- 	function()
		-- 		Snacks.picker.lsp_workspace_symbols()
		-- 	end,
		-- 	desc = "LSP Workspace Symbols",
		-- },
		-- Other
		-- {
		-- 	"<leader>bd",
		-- 	function()
		-- 		Snacks.bufdelete()
		-- 	end,
		-- 	desc = "Delete Buffer",
		-- },
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
