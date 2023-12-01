return {
  "kristijanhusak/vim-dadbod-ui",
  config = function()
    local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
    local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

    -- Disable omnifunc for sql as it is annoying when I press <C-c> in insert mode
    vim.g.omni_sql_no_default_maps = 1

    -- Use nerd fonts for the UI
    vim.g.db_ui_use_nerd_fonts = 1

    -- Use a drawer with a bigger width
    vim.g.db_ui_winwidth = 60

    -- Don't execute sql when saving an sql buffer
    vim.g.db_ui_execute_on_save = 0

    -- Position the drawer on the right side of the window
    vim.g.db_ui_win_position = "right"

    -- Don't use neovim's notfication system
    vim.g.db_ui_use_nvim_notify = 0

    -- Open DB connections window
    vim.keymap.set("n", "<leader>db", ":tabnew<CR>:DBUI<CR>", { silent = true })

    augroup("dadbod-ui", { clear = true })
    autocmd("FileType", {
      group = "dadbod-ui",
      pattern = "dbui",
      callback = function()
        -- Unmap these as I use <C-J/K> for navigating windows
        -- vim.keymap.del("n", "<C-j>", { buffer = 0 })
        -- vim.keymap.del()
        -- vim.keymap.del("n", "<C-k>", { buffer = 0 })
        --
        -- -- Unmap these as they are annoying
        -- vim.keymap.del("n", "<C-p>", { buffer = 0 })
        -- vim.keymap.del("n", "<C-n>", { buffer = 0 })

        vim.keymap.set("n", "<Tab>", "<Plug>(DBUI_SelectLine)", { buffer = 0 })
      end,
    })
  end
}
