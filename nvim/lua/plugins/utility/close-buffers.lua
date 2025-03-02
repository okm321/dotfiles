return {
	"kazhala/close-buffers.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		-- 設定例
		require("close_buffers").setup({
			-- 設定オプションはここに記述
			preserve_window_layout = { "this", "prev" }, -- ウィンドウレイアウトを維持
			next_buffer_cmd = function(windows)
				require("bufferline").cycle(-1) -- 'bufferline.nvim' を使ってバッファを切り替える例
			end,
		})
		vim.keymap.set("n", "<leader>e", [[<CMD>lua require('close_buffers').delete({type = 'this'})<CR>]])
	end,
}
