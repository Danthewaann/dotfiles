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
})

vim.keymap.set("n", "<C-n>", "<cmd> silent NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>nf", "<cmd> silent NvimTreeFindFile<CR>")

