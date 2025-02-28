return {
    "shaunsingh/nord.nvim",
    config = function()
        require("nord").set()
        vim.cmd [[colorscheme nord]]
    end,
}
