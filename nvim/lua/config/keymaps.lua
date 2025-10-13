local keymap = vim.keymap

vim.cmd("command! Nw noautocmd w")
vim.cmd("command! Nwq noautocmd wq")

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

-- 診断の仮想テキストを即座に無効化
vim.keymap.set("n", "<leader>dv", function()
	vim.diagnostic.config({ virtual_text = false })
end, { desc = "Disable diagnostic virtual text", silent = true })
