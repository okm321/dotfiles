return {
	"monaqa/dial.nvim",
	keys = {
		{
			"+",
			"<Cmd>DialIncrement<CR>",
			mode = { "n", "v" },
			desc = "Increment number under the cursor",
		},
		{
			"-",
			"<Cmd>DialDecrement<CR>",
			mode = { "n", "v" },
			desc = "Decrement number under the cursor",
		},
		{
			"g+",
			"<Cmd>DialIncrement<CR>",
			mode = { "n", "v" },
			desc = "Increment number under the cursor",
		},
		{
			"g-",
			"<Cmd>DialDecrement<CR>",
			mode = { "n", "v" },
			desc = "Decrement number under the cursor",
		},
	},
	config = function()
		local augend = require("dial.augend")
		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.date.alias["%Y/%m/%d"],
				augend.date.alias["%m/%d"],
				augend.date.alias["%-m/%-d"],
				augend.date.alias["%Y-%m-%d"],
				augend.date.alias["%Y年%-m月%-d日"],
				augend.date.alias["%Y年%-m月%-d日(%ja)"],
				augend.date.alias["%H:%M:%S"],
				augend.date.alias["%H:%M"],
				augend.constant.alias.ja_weekday,
				augend.constant.alias.ja_weekday_full,
				augend.constant.alias.bool,
				augend.semver.alias.semver,
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "local", "dev", "qa", "stg", "prd" },
					word = false,
					cyclic = true,
				}),
			},
		})
	end,
}
