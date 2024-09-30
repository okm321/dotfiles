-- Neovimのデータディレクトリのパスに "lazy/lazy.nvim" を追加, プラグインの保存パスを設定
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- 指定されたパスにプラグインが存在しない場合, Gitを使ってプラグインをクローン
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

-- ランタイムパスの先頭にプラグインのパスを追加
vim.opt.rtp:prepend(lazypath)