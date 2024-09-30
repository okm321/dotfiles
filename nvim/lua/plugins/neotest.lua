local function find_jest_config_dir(path)
	local dir = vim.fn.fnamemodify(path, ":h")

	while dir ~= "" do
		local jest_config = dir .. "/jest.config.ts"
		if vim.fn.filereadable(jest_config) == 1 then
			return dir
		end
		dir = vim.fn.fnamemodify(dir, ":h")
	end
end

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"haydenmeade/neotest-jest",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npm run test --",
					jestConfigFile = "jest.config.ts",
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
			},
		})
	end,
}
