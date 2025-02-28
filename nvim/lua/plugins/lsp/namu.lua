return {
    "bassamsdata/namu.nvim",
    event = { "BufRead" },
    config = function()
        require("namu").setup()
        -- === Suggested Keymaps: ===
        vim.keymap.set("n", "<leader>ss", ":Namu symbols<cr>", {
            desc = "Jump to LSP symbol",
            silent = true,
        })
    end,
}
