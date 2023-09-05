local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '?',     api.tree.toggle_help,                opts('Help'))
end

require("nvim-tree").setup({
    on_attach = my_on_attach,
    git = {
        enable = true,
        ignore = false,
    },
    view = {
        width = 50,
        side = "right"
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

vim.keymap.set("n", "<C-n>", "<cmd> silent NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd> silent NvimTreeFindFile<CR>")

