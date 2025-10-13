return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
		},
		"rafamadriz/friendly-snippets",
		"moyiz/blink-emoji.nvim",
		"jdrupal-dev/css-vars.nvim",
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		appearance = { nerd_font_variant = "mono" },
		keymap = {
			preset = "enter",
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "fallback" },
		},
		completion = {
			menu = {
				border = "single",
				draw = {
					treesitter = { "lsp" },
					columns = { { "kind_icon" }, { "label", gap = 1 } },
					components = {
						label = {
							text = function(ctx)
								return require("colorful-menu").blink_components_text(ctx)
							end,
							highlight = function(ctx)
								return require("colorful-menu").blink_components_highlight(ctx)
							end,
						},
					},
				},
			},
			list = {
				selection = { preselect = true, auto_insert = true },
			},
			documentation = { auto_show = true, window = { border = "single" }, auto_show_delay_ms = 100 },
			ghost_text = { enabled = false },
		},
		fuzzy = {
			-- version指定なしだとLua実装にフォールバックした際に警告が出るのでRust優先
			implementation = "prefer_rust_with_warning",
		},
		snippets = {
			preset = "luasnip",
		},
		sources = {
			default = { "lsp", "path", "buffer", "snippets", "emoji" },
			providers = {
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15, -- Tune by preference
					opts = {
						insert = true, -- Insert emoji (default) or complete its name
						---@type string|table|fun():table
						trigger = function()
							return { ":" }
						end,
					},
					should_show_items = function()
						return vim.tbl_contains(
							-- Enable emoji completion only for git commits and markdown.
							-- By default, enabled for all file-types.
							{ "gitcommit", "markdown" },
							vim.o.filetype
						)
					end,
				},
				css_vars = {
					name = "css-vars",
					module = "css-vars.blink",
					opts = {
						-- WARNING: The search is not optimized to look for variables in JS files.
						-- If you change the search_extensions you might get false positives and weird completion results.
						search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
					},
				},
				snippets = {
					opts = {
						friendly_snippets = true,
					},
				},
			},
		},
		signature = { enabled = false },
		cmdline = {
			keymap = {
				-- recommended, as the default keymap will only show and select the next item
				["<Tab>"] = { "show", "accept" },
			},
			completion = {
				menu = { auto_show = true },
				ghost_text = { enabled = false },
			},
		},
	},
	opts_extend = { "sources.default" },
	config = function(_, opts)
		local blink = require("blink.cmp")
		blink.setup(opts)

		local ok, loader = pcall(require, "luasnip.loaders.from_vscode")
		if ok then
			loader.lazy_load()
		end
	end,
}
