return {
    "rest-nvim/rest.nvim",
    commit = '8b62563cfb19ffe939a260504944c5975796a682', -- For https://github.com/rest-nvim/rest.nvim/issues/246
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("rest-nvim").setup({})

        vim.keymap.set('n', '<leader>pp', '<Plug>RestNvim')
        vim.keymap.set('n', '<leader>pl', '<Plug>RestNvimPreview')
    end
}
