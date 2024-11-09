local keymap = vim.keymap

-- Leader key
vim.g.mapleader = " "

-- Do not yank with x
keymap.set("n", "x", '"_x')

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d')

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- New tab
keymap.set("n", "te", ":tabedit<Return>", { silent = true })
keymap.set("n", "tn", ":tabn<Return>", { silent = true })
keymap.set("n", "tp", ":tabp<Return>", { silent = true })
-- Split window
keymap.set("n", "ss", ":split<Return><C-w>W", { silent = true })
keymap.set("n", "sv", ":vsplit<Return><C-w>W", { silent = true })
-- Move window
keymap.set("n", "<Space>", "<C-w>W")
keymap.set("", "s<left>", "<C-w>h")
keymap.set("", "s<up>", "<C-w>k")
keymap.set("", "s<down>", "<C-w>j")
keymap.set("", "s<right>", "<C-w>l")
keymap.set("", "sh", "<C-w>h")
keymap.set("", "sk", "<C-w>k")
keymap.set("", "sj", "<C-w>j")
keymap.set("", "sl", "<C-w>l")

-- Visualモードで選択範囲を一行上に移動
vim.api.nvim_set_keymap("x", "<C-k>", ":move '<-2<CR>gv-gv", { noremap = true, silent = true })
-- Visualモードで選択範囲を一行下に移動
vim.api.nvim_set_keymap("x", "<C-j>", ":move '>+1<CR>gv-gv", { noremap = true, silent = true })

-- Resize window
keymap.set("n", "<C-w><left>", "<C-w><")
keymap.set("n", "<C-w><right>", "<C-w>>")
keymap.set("n", "<C-w><up>", "<C-w>+")
keymap.set("n", "<C-w><down>", "<C-w>-")

-- neo-tree
keymap.set("n", "<C-q>", ":Neotree toggle<Return>", { noremap = true, silent = true })

-- barbar
keymap.set("n", "<S-l>", "<Cmd>BufferNext<CR>", { noremap = true, silent = true })
keymap.set("n", "<S-h>", "<Cmd>BufferPrevious<CR>", { noremap = true, silent = true })
keymap.set("n", "<S-t>", "<Cmd>BufferRestore<CR>", { noremap = true, silent = true })
keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>e", "<Cmd>BufferClose<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>bb", "<Cmd>BufferOrderByBufferNumber<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>bd", "<Cmd>BufferOrderByDirectory<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>bl", "<Cmd>BufferOrderByLanguage<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>bn", "<Cmd>BufferOrderByName<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>bw", "<Cmd>BufferOrderByWindowNumber<CR>", { noremap = true, silent = true })

-- close-buffers
vim.keymap.set(
	"n",
	"<Leader>th",
	[[<CMD>lua require('close_buffers').delete({type = 'hidden'})<CR>]],
	{ noremap = true, silent = true }
)

-- dial
vim.keymap.set("n", "+", function()
	require("dial.map").manipulate("increment", "normal")
end)
vim.keymap.set("n", "-", function()
	require("dial.map").manipulate("decrement", "normal")
end)
vim.keymap.set("n", "g+", function()
	require("dial.map").manipulate("increment", "gnormal")
end)
vim.keymap.set("n", "g-", function()
	require("dial.map").manipulate("decrement", "gnormal")
end)
vim.keymap.set("v", "+", function()
	require("dial.map").manipulate("increment", "visual")
end)
vim.keymap.set("v", "-", function()
	require("dial.map").manipulate("decrement", "visual")
end)
vim.keymap.set("v", "g+", function()
	require("dial.map").manipulate("increment", "gvisual")
end)
vim.keymap.set("v", "g-", function()
	require("dial.map").manipulate("decrement", "gvisual")
end)

-- copilot
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-l>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Telescope
keymap.set("n", "<leader>ff", "<CMD>Telescope find_files<CR>", {})
-- keymap.set("n", "<leader>fg", "<CMD>Telescope live_grep<CR>", {})
keymap.set("n", "<leader>fg", function()
	require("telescope.builtin").live_grep({
		glob_pattern = "!.git",
	})
end, {})
-- keymap.set("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>", {})
keymap.set(
	"n",
	"<leader>fr",
	"<CMD>Telescope frecency workspace=CWD prompt_title=frecency path_display={'filename_first'}<CR>",
	{}
)
keymap.set("n", "<leader>fb", "<CMD>Telescope buffers<CR>", {})
keymap.set("n", "<leader>fh", "<CMD>Telescope help_tags<CR>", {})
keymap.set("n", "<leader>gs", "<CMD>Telescope git_status<CR>", {})
keymap.set("n", "<leader>gc", "<CMD>Telescope git_commits<CR>", {})
keymap.set("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", {})
-- Telescope file browser
keymap.set("n", "<leader>tfb", "<CMD>Telescope file_browser<CR>", {})

-- lspsaga or lsp
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
vim.keymap.set("n", "gd", "<Cmd>Lspsaga finder tyd+ref+imp+def<CR>", opts)
vim.keymap.set("n", "gr", "<Cmd>Lspsaga finder ref<CR>", opts)
vim.keymap.set("n", "gi", "<Cmd>Lspsaga finder imp<CR>", opts)
vim.keymap.set("n", "gt", "<Cmd>Lspsaga goto_definition<CR>", opts)
vim.keymap.set("i", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
vim.keymap.set("n", "gp", "<Cmd>Lspsaga preview_definition<CR>", opts)
vim.keymap.set("n", "<leader>rn", "<Cmd>Lspsaga rename<CR>", opts)

vim.api.nvim_set_keymap("n", "M", "q", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })

keymap.set("n", "<leader>ch", "<cmd>Chowcho<cr>", { noremap = true, silent = true })

-- https://zenn.dev/vim_jp/articles/38915175fe4648#fn-368c-2
vim.keymap.set("n", "<leader>*", "*''cgn")
vim.keymap.set("x", "<leader>r", 'y:%s/<C-r><C-r>"//g<Left><Left>')
vim.keymap.set("n", "<leader>r", 'yiw:%s/<C-r><C-r>"//g<Left><Left')

-- url-open
vim.keymap.set("n", "gx", "<esc>:URLOpenUnderCursor<cr>")

-- windows
local function cmd(command)
	return table.concat({ "<Cmd>", command, "<CR>" })
end

vim.keymap.set("n", "<C-w>z", cmd("WindowsMaximize"))
vim.keymap.set("n", "<C-w>_", cmd("WindowsMaximizeVertically"))
vim.keymap.set("n", "<C-w>|", cmd("WindowsMaximizeHorizontally"))
vim.keymap.set("n", "<C-w>=", cmd("WindowsEqualize"))

-- vim-doge
vim.api.nvim_set_keymap("n", "<Leader>d", ":DogeGenerate<CR>", { noremap = true, silent = true })

-- syntax-tree-surfer
-- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vU", function()
	vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vD", function()
	vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

-- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
vim.keymap.set("n", "vd", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })
vim.keymap.set("n", "vu", function()
	vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
	return "g@l"
end, { silent = true, expr = true })

-- Visual Selection from Normal Mode
vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", { silent = true, noremap = true })

-- Select Nodes in Visual Mode
vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", { silent = true, noremap = true })
vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", { silent = true, noremap = true })
vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", { silent = true, noremap = true })
vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", { silent = true, noremap = true })

-- Swapping Nodes in Visual Mode
vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", { silent = true, noremap = true })
vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", { silent = true, noremap = true })

-- Holds a node, or swaps the held node
vim.keymap.set("n", "gnh", "<cmd>STSSwapOrHold<cr>", { silent = true, noremap = true })
-- Same for visual
vim.keymap.set("x", "gnh", "<cmd>STSSwapOrHoldVisual<cr>", { silent = true, noremap = true })

-- yanky
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)")
vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- nvim-spectre
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

-- vim-terreform settings
vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
vim.cmd([[let g:terraform_fmt_on_save=1]])
vim.cmd([[let g:terraform_align=1]])

-- tsx, ts, js, jsxファイル保存時にeslint_dによるautofixを実行
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.tsx", "*.ts", "*.js", "*.jsx" },
	callback = function()
		-- カーソル位置の取得
		local cursor = vim.api.nvim_win_get_cursor(0)

		-- eslint_d の結果を変数に格納
		local result = vim.fn.system(
			"eslint_d --fix-to-stdout --stdin --stdin-filename " .. vim.fn.shellescape(vim.api.nvim_buf_get_name(0)),
			vim.api.nvim_buf_get_lines(0, 0, -1, true) -- ファイル内容をstdinに送る
		)

		-- eslint_d が成功した場合のみ修正を適用
		if vim.v.shell_error == 0 then
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(result, "\n"))
			-- else
			-- 	print("eslint_d failed: " .. result)
		end

		-- カーソル位置の設定
		vim.api.nvim_win_set_cursor(0, cursor)
	end,
})
