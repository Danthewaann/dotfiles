local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<C-t>', api.tree.change_root_to_node,        opts('Up'))
    vim.keymap.set('n', '?',     api.tree.toggle_help,                opts('Help'))
end

require("nvim-tree").setup({
    on_attach = my_on_attach,
    git = {
        enable = true,
        ignore = false,
    },
    view = {
        width = 35,
    },
    renderer = {
        full_name = true,
        root_folder_label = false
    },
    tab = {
        sync = {
            close = true
        }
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})

vim.keymap.set("n", "<C-n>", "<cmd> silent NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd> silent NvimTreeFindFile<CR>")

