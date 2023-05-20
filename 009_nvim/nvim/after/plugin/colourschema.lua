vim.cmd[[colorscheme onedark]]

vim.cmd("highlight NvimTreeNormal guibg=#282c34 guifg=#9da5b3")
vim.cmd("highlight NvimTreeNormalFloat guibg=#282c34 guifg=#9da5b3")
vim.cmd("highlight NvimTreeEndOfBuffer guibg=#282c34 guifg=#282c34")

require("nvim-tree").setup({})
