vim.lsp.config("eslint", {
  workspace_required = true,
  -- on_attach = function(client, bufnr)
    -- 通常のキーマッピング等

    -- ファイル保存時にESLintのコードアクションを実行
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   buffer = bufnr,
    --   callback = function()
    --     client.server_capabilities.documentFormattingProvider = true
    --     vim.lsp.buf.format({ async = false })
    --   end,
    -- })
  -- end,
})
