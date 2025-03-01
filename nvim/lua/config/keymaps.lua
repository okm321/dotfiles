local keymap = vim.keymap

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- dとcをブラックホールレジスタに送る
vim.keymap.set("n", "d", '"_d', { noremap = true })
vim.keymap.set("n", "D", '"_D', { noremap = true })
vim.keymap.set("v", "d", '"_d', { noremap = true })
vim.keymap.set("n", "dd", '"_dd', { noremap = true })
vim.keymap.set("n", "c", '"_c', { noremap = true })
vim.keymap.set("n", "C", '"_C', { noremap = true })
vim.keymap.set("v", "c", '"_c', { noremap = true })

-- xにオペレータとしての機能を追加（d自体の元の機能を使う）
vim.keymap.set("n", "x", "d", { noremap = true })
vim.keymap.set("n", "xx", "dd", { noremap = false }) -- 行全体の削除でヤンク
vim.keymap.set("n", "X", "D", { noremap = false }) -- 行末までの削除でヤンク

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
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

-- 間違えてマクロ記録を始めないようにkeymap
vim.api.nvim_set_keymap("n", "M", "q", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "q", "<Nop>", { noremap = true, silent = true })

-- highlightのクリア
vim.api.nvim_set_keymap("n", "<leader>l", "<Cmd>noh<CR>", { noremap = true, silent = true })

--- 再度入れるか考え直し ---

-- keymap.set("n", "<leader>ch", "<cmd>Chowcho<cr>", { noremap = true, silent = true })

-- -- https://zenn.dev/vim_jp/articles/38915175fe4648#fn-368c-2
-- vim.keymap.set("n", "<leader>*", "*''cgn")
-- vim.keymap.set("x", "<leader>r", 'y:%s/<C-r><C-r>"//g<Left><Left>')
-- vim.keymap.set("n", "<leader>r", 'yiw:%s/<C-r><C-r>"//g<Left><Left')

-- -- vim-doge
-- vim.api.nvim_set_keymap("n", "<Leader>d", ":DogeGenerate<CR>", { noremap = true, silent = true })

-- -- syntax-tree-surfer
-- -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
-- vim.keymap.set("n", "vU", function()
-- 	vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
-- 	return "g@l"
-- end, { silent = true, expr = true })
-- vim.keymap.set("n", "vD", function()
-- 	vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
-- 	return "g@l"
-- end, { silent = true, expr = true })

-- -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
-- vim.keymap.set("n", "vd", function()
-- 	vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
-- 	return "g@l"
-- end, { silent = true, expr = true })
-- vim.keymap.set("n", "vu", function()
-- 	vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
-- 	return "g@l"
-- end, { silent = true, expr = true })

-- -- Visual Selection from Normal Mode
-- vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", { silent = true, noremap = true })
-- vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", { silent = true, noremap = true })

-- -- Select Nodes in Visual Mode
-- vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", { silent = true, noremap = true })
-- vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", { silent = true, noremap = true })
-- vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", { silent = true, noremap = true })
-- vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", { silent = true, noremap = true })

-- -- Swapping Nodes in Visual Mode
-- vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", { silent = true, noremap = true })
-- vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", { silent = true, noremap = true })

-- -- Holds a node, or swaps the held node
-- vim.keymap.set("n", "gnh", "<cmd>STSSwapOrHold<cr>", { silent = true, noremap = true })
-- -- Same for visual
-- vim.keymap.set("x", "gnh", "<cmd>STSSwapOrHoldVisual<cr>", { silent = true, noremap = true })

-- -- vim-terreform settings
-- vim.cmd([[silent! autocmd! filetypedetect BufRead,BufNewFile *.tf]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.hcl set filetype=hcl]])
-- vim.cmd([[autocmd BufRead,BufNewFile .terraformrc,terraform.rc set filetype=hcl]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.tf,*.tfvars set filetype=terraform]])
-- vim.cmd([[autocmd BufRead,BufNewFile *.tfstate,*.tfstate.backup set filetype=json]])
-- vim.cmd([[let g:terraform_fmt_on_save=1]])
-- vim.cmd([[let g:terraform_align=1]])
