return {
    'nvim-tree/nvim-web-devicons',
    config = function()
        require 'nvim-web-devicons'.setup {
            default = true,
            override = {
                ts = {
                    icon = '󰛦',
                    color = "#519aba",
                    cterm_color = "74",
                    name = "TypeScript",
                },
                ['stories.tsx'] = {
                    icon = '',
                    color = "#FF4785",
                    cterm_color = "167",
                    name = "Storybook",

                },
                GitUntracked = {
                    icon = "",
                    color = "#FFCC00",
                    name = "GitUntracked",
                },
            }
        }
    end
}
