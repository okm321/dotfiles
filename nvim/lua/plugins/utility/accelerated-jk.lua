return {
    "rainbowhxch/accelerated-jk.nvim",
    config = function()
        require("accelerated-jk").setup()
        vim.keymap.set("n", "j", "<Plug>(accelerated_jk_gj)")
        vim.keymap.set("n", "k", "<Plug>(accelerated_jk_gk)")
    end,
}
