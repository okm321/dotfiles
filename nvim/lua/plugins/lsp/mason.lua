return {
	"williamboman/mason.nvim",
	cmd = "Mason",
	build = ":MasonUpdate",
	opts = {
		-- リンターやフォーマッタなど必要なツールを指定
		ensure_installed = {
			-- リンター
			"eslint_d",
			"biome",

			-- フォーマッター
			"prettier",
			"stylua",

			-- その他必要なツール
			"markdownlint-cli2",
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)

		-- ensure_installedに指定したツールのインストール
		local registry = require("mason-registry")
		local function ensure_installed()
			for _, tool in ipairs(opts.ensure_installed) do
				local p = registry.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end

		if registry.refresh then
			registry.refresh(ensure_installed)
		else
			ensure_installed()
		end
	end,
}
