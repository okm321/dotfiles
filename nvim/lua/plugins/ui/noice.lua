return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
        messages = {
            enabled = true,
            view = 'mini',
            view_error = 'mini',
            view_warn = 'mini',
            view_history = 'messages',
            view_searchi = 'mini'
        }
    },
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    }
}
