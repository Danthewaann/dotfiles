return {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function ()
        require('neogen').setup {
            enabled = true,             --if you want to disable Neogen
            input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
            -- jump_map = "<C-e>"       -- (DROPPED SUPPORT, see [here](#cycle-between-annotations) !) The keymap in order to jump in the annotation fields (in insert mode)
        }

        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader>ds", ":lua require('neogen').generate()<CR>", opts)
    end
}
