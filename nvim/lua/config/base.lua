-- 既存のautocommandをクリア
vim.api.nvim_clear_autocmds({})

-- obsidianで設定
vim.opt.conceallevel = 2

-- エンコーディング設定
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- 画面分割設定
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 表示設定
vim.wo.number = true
vim.opt.title = true
vim.opt.hlsearch = true
vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.scrolloff = 10
vim.opt.wrap = false -- 行の折り返しなし

-- インデント設定
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smarttab = true
vim.opt.breakindent = true

-- 特殊文字の表示
vim.opt.list = true
vim.opt.listchars = { tab = "▏ ", trail = "*", nbsp = "+" }

-- 検索設定
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- ファイル関連設定
vim.opt.backup = false
vim.opt.backupskip = "/tmp/*,/private/tmp/*"
vim.opt.backspace = "start,eol,indent"
vim.opt.path:append({ "**" }) -- サブフォルダ内のファイル検索
vim.opt.wildignore:append({ "*/node_modules/*" })

-- LSP設定
vim.lsp.set_log_level("ERROR")

-- オートコマンド
-- インサートモードを抜けたときにペーストモードをオフ
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	callback = function()
		vim.opt.paste = false
	end,
})

-- formatoptionsはバッファローカルなので、autocmdで設定
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:append({ "r" })
	end,
})

-- see: https://github.com/coder/claudecode.nvim/issues/52#issuecomment-2994326218
-- vim.env.CLAUDE_CONFIG_DIR = vim.fn.expand("~/.config/claude")

-- なんかavanteでmonorepoの場合diff表示する時にnew bufになるから入れてる
-- https://github.com/yetone/avante.nvim/issues/1759#issuecomment-2770887161
-- local chdir = vim.api.nvim_create_augroup("chdir", {})
--
-- vim.api.nvim_create_autocmd("BufEnter", {
-- 	group = chdir,
-- 	nested = true,
-- 	callback = function()
-- 		vim.go.autochdir = not vim.bo.filetype:match("^Avante")
-- 	end,
-- })
