return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter", -- 挿入モードに入った時に読み込む
	dependencies = {
		"hrsh7th/cmp-nvim-lsp", -- LSP補完ソース
		"hrsh7th/cmp-buffer", -- バッファ補完ソース
		"hrsh7th/cmp-path", -- ファイルパス補完ソース
		"hrsh7th/cmp-cmdline", -- コマンドライン補完ソース
		"L3MON4D3/LuaSnip", -- スニペットエンジン
		"saadparwaiz1/cmp_luasnip", -- スニペット補完ソース
		"rafamadriz/friendly-snippets", -- スニペットのプリセット集
		"onsails/lspkind.nvim",
		-- "zbirenbaum/copilot-cmp",
		"f3fora/cmp-spell",
		"hrsh7th/cmp-emoji",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body) -- LuaSnip を使用してスニペットを展開
				end,
			},
			mapping = {
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-d>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),

				["<Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif require("luasnip").expand_or_jumpable() then
						require("luasnip").expand_or_jump()
					else
						fallback()
					end
				end,
				["<S-Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif require("luasnip").jumpable(-1) then
						require("luasnip").jump(-1)
					else
						fallback()
					end
				end,

				-- 手動トリガー用の <Tab> と <S-Tab> の設定を追加
				--[[ ["<Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						cmp.complete()
					end
				end,
				["<S-Tab>"] = function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						cmp.complete()
					end
				end, ]]
			},
			sources = cmp.config.sources({
				{ name = "luasnip", option = { show_autosnippets = true } }, -- スニペットからの補完
				{ name = "nvim_lsp" }, -- LSPからの補完
				{ name = "emoji" },
				-- { name = "copilot" },
				{
					name = "spell",
					option = {
						keep_all_entries = false,
						enable_in_context = function()
							return true
						end,
						preselect_correct_word = true,
					},
				},
			}, {
				{ name = "buffer" }, -- バッファからの補完
				{ name = "path" }, -- ファイルパスからの補完
			}),
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text", -- アイコンとテキストを表示
					maxwidth = 100, -- ポップアップの最大幅を設定
					ellipsis_char = "...", -- 長いテキストに対して省略記号を設定
					symbol_map = {
						Text = "󰉿",
						Method = "󰆧",
						Function = "󰊕",
						Constructor = "",
						Field = "󰜢",
						Variable = "󰀫",
						Class = "󰠱",
						Interface = "",
						Module = "",
						Property = "󰜢",
						Unit = "󰑭",
						Value = "󰎠",
						Enum = "",
						Keyword = "󰌋",
						Snippet = "",
						Color = "󰏘",
						File = "󰈙",
						Reference = "󰈇",
						Folder = "󰉋",
						EnumMember = "",
						Constant = "󰏿",
						Struct = "󰙅",
						Event = "",
						Operator = "󰆕",
						TypeParameter = "",
						Copilot = "",
					},
				}),
			},
		})

		-- コマンドライン用の設定
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}),
		})
	end,
}
