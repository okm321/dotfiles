-- dart は fvm global の SDK を PATH 経由で使う (~/fvm/default/bin)
---@type vim.lsp.Config
return {
	cmd = { "dart", "language-server", "--protocol=lsp" },
	filetypes = { "dart" },
	root_markers = { "pubspec.yaml" },
	-- closingLabels/outline/flutterOutline は nvim 側に描画ハンドラが無く
	-- サーバーの計算・通知が無駄になるだけなので有効化しない
	init_options = {
		onlyAnalyzeProjectsWithOpenFiles = true,
		suggestFromUnimportedLibraries = true,
	},
	settings = {
		dart = {
			completeFunctionCalls = true,
			showTodos = true,
		},
	},
	-- dartls の inlay hint は型引数・引数名まで出て冗長なので常に無効化
	-- (<leader>ih のグローバルトグルにも反応させない)
	on_attach = function(client)
		client.server_capabilities.inlayHintProvider = nil
	end,
}
