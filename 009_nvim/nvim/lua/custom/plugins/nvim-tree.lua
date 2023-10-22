return {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
    },
    config = function()
        local function my_on_attach(bufnr)
            local api = require("nvim-tree.api")

            local function opts(desc)
                return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
            end

            -- default mappings
            api.config.mappings.default_on_attach(bufnr)

            -- custom mappings
            vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
        end

        require("nvim-tree").setup({
            on_attach = my_on_attach,
            git = {
                enable = true,
                ignore = false,
            },
            view = {
                width = 50,
                side = "right",
                float = {
                    enable = true,
                    open_win_config = {
                        relative = "editor",
                        border = "rounded",
                        width = 50,
                        height = vim.api.nvim_win_get_height(0) - 1,
                        row = 1,
                        col = vim.api.nvim_win_get_width(0) - 1,
                    }
                }
            },
            renderer = {
                add_trailing = true,
                full_name = true,
                root_folder_label = false
            },
            tab = {
                sync = {
                    open = true,
                    close = true
                }
            },
        })

        vim.keymap.set("n", "<leader>ft", "<cmd> silent NvimTreeToggle<CR>", {desc = '[F]ile [T]ree'})
        vim.keymap.set("n", "<leader>ff", "<cmd> silent NvimTreeFindFile<CR>", {desc = '[F]ile [F]ind'})
    end
}
