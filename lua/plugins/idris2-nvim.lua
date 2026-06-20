return {
        "idris-community/idris2-nvim",
        dependencies = { 'neovim/nvim-lspconfig', 'MunifTanjim/nui.nvim' },

        config = function()
                local code_action = require('idris2.code_action')

                local filters = code_action.filters
                local introspect = code_action.introspect_filter
                local function save_hook(action)
                        -- https://github.com/idris-community/idris2-nvim/issues/33#issuecomment-2425178847
                        if not action or not action.title then
                                return
                        end

                        if introspect(action) == filters.MAKE_CASE
                            or introspect(action) == filters.MAKE_WITH then
                                return
                        end
                        vim.cmd('silent write')
                end

                require('idris2').setup({
                        code_action_post_hook = save_hook,
                })
        end,
}

