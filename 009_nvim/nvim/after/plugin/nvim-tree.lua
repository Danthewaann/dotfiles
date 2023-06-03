require("nvim-tree").setup({
    git = {
        enable = true,
        ignore = false,
    },
    view = {
        width = 35,
    },
    renderer = {
        full_name = true,
    },
    tab = {
        sync = {
            open = true,
            close = true,
        },
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})

vim.keymap.set("n", "<C-n>", "<cmd> silent NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd> silent NvimTreeFindFile<CR>")

