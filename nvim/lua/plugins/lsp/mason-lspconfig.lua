return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    opts = {
        ensure_installed = {
            -- TypeScript/JavaScript
            "ts_ls",         -- TypeScript
            "eslint",        -- ESLint
            "biome",         -- Biome
            -- Vue
            "volar",         -- Vue
            -- Go
            "gopls",         -- Go
            -- HTML/CSS
            "html",          -- HTML
            "cssls",         -- CSS
            "cssmodules_ls", -- CSS Modules
            "css_variables", -- CSS Variables
            "tailwindcss",   -- Tailwind CSS
            -- 各種設定ファイル
            "jsonls",        -- JSON
            "yamlls",        -- YAML
            "taplo",         -- TOML
            -- SQL
            "sqls",          -- SQL
            -- terraform
            "terraformls",   -- Terraform
            "tflint",        -- TFLint
            -- Docker
            "dockerls",      -- Docker
            -- Bash
            "bashls",        -- Bash
            -- Neovim設定用
            "lua_ls",        -- Lua
            -- タイポ
            "typos_lsp",     -- Typos
        },
        automatic_installation = true,
    }
}
