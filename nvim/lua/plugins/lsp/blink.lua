return {
	-- "saghen/blink.cmp",
	-- version = "*",
	-- event = { "InsertEnter", "CmdLineEnter" },
	-- dependencies = {
	-- 	{ "L3MON4D3/LuaSnip", event = { "InsertEnter" } }, -- スニペットエンジン
	-- 	{ "rafamadriz/friendly-snippets", event = { "InsertEnter" } }, -- スニペットコレクション
	-- 	{ "xzbdmw/colorful-menu.nvim", event = { "InsertEnter" } },
	-- 	{ "jdrupal-dev/css-vars.nvim", event = { "InsertEnter" } },
	-- },
	-- ---@module 'blink.cmp'
	-- ---@type blink.cmp.Config
	-- opts = {
	-- 	snippets = {
	-- 		preset = "luasnip",
	-- 	},
	-- 	sources = {
	-- 		default = {
	-- 			"snippets",
	-- 			"lsp",
	-- 			"path",
	-- 			"buffer",
	-- 		},
	-- 		per_filetype = { sql = { "dadbod" } },
	-- 		providers = {
	-- 			dadbod = { module = "vim_dadbod_completion.blink" },
	-- 			css_vars = {
	-- 				name = "css-vars",
	-- 				module = "css-vars.blink",
	-- 				opts = {
	-- 					-- WARNING: The search is not optimized to look for variables in JS files.
	-- 					-- If you change the search_extensions you might get false positives and weird completion results.
	-- 					-- search_extensions = { ".js", ".ts", ".jsx", ".tsx" },
	-- 				},
	-- 			},
	-- 		},
	-- 	},
	-- 	keymap = {
	-- 		preset = "enter",
	-- 	},
	-- 	signature = { enabled = true },
	-- 	completion = {
	-- 		trigger = {
	-- 			show_on_keyword = true,
	-- 		},
	-- 		documentation = {
	-- 			auto_show = true,
	-- 			auto_show_delay_ms = 500,
	-- 			window = { border = "single" },
	-- 		},
	-- 		menu = {
	-- 			border = "single",
	-- 			draw = {
	-- 				-- We don't need label_description now because label and label_description are already
	-- 				-- combined together in label by colorful-menu.nvim.
	-- 				columns = { { "kind_icon" }, { "label", gap = 1 } },
	-- 				components = {
	-- 					label = {
	-- 						text = function(ctx)
	-- 							return require("colorful-menu").blink_components_text(ctx)
	-- 						end,
	-- 						highlight = function(ctx)
	-- 							return require("colorful-menu").blink_components_highlight(ctx)
	-- 						end,
	-- 					},
	-- 				},
	-- 				-- treesitter = { "lsp" },
	-- 				-- columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind", gap = 1 } },
	-- 				-- components = {
	-- 				-- 	kind = {
	-- 				-- 		text = function(ctx)
	-- 				-- 			local len = 10 - string.len(ctx.kind)
	-- 				-- 			local space = string.rep(" ", len)
	-- 				-- 			return ctx.kind .. space .. "[" .. ctx.source_name .. "]"
	-- 				-- 		end,
	-- 				-- 	},
	-- 				-- },
	-- 			},
	-- 		},
	-- 		list = {
	-- 			selection = {
	-- 				preselect = true,
	-- 				auto_insert = true,
	-- 			},
	-- 		},
	-- 	},
	-- 	cmdline = {
	-- 		completion = {
	-- 			ghost_text = {
	-- 				enabled = true,
	-- 			},
	-- 			menu = {
	-- 				auto_show = true,
	-- 			},
	-- 		},
	-- 	},
	-- },
	-- opts_extend = { "sources.default" },
}
