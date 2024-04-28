return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup {
            theme = 'doom',
            config = {
                center = {
                    {
                        icon = ' ',
                        icon_hl = 'Title',
                        desc = 'Find File           ',
                        desc_hl = 'String',
                        key = 'b',
                        keymap = 'SPC s f',
                        key_hl = 'Number',
                        key_format = ' %s', -- remove default surrounding `[]`
                        action = 'lua print(2)'
                    },
                    {
                        icon = ' ',
                        desc = 'Find Dotfiles',
                        key = 'f',
                        keymap = 'SPC s d',
                        key_format = ' %s', -- remove default surrounding `[]`
                        action = 'lua print(3)'
                    },
                }
            }
        }
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}
