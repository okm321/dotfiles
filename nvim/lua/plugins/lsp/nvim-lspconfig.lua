return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/cmp-nvim-lsp" }, -- LSPソースを補完エンジンに提供
  },
  event = { "BufReadPre", "BufNewFile" },
}
