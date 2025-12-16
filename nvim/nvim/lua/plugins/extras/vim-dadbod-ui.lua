return {
  "kristijanhusak/vim-dadbod-ui",
  keys = {
    {
      -- Open DB connections window
      "<leader>db",
      "<cmd> tab DBUI<CR>",
      silent = true,
      desc = "Open [DB] UI"
    }
  },
  dependencies = { "tpope/vim-dadbod" },
  config = function()
    local utils = require("custom.utils")
    local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
    local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

    -- Disable omnifunc for sql as it is annoying when I press <C-c> in insert mode
    vim.g.omni_sql_no_default_maps = 1

    -- Use nerd fonts for the UI
    vim.g.db_ui_use_nerd_fonts = 1

    -- Use a drawer with a bigger width
    vim.g.db_ui_winwidth = 40

    -- Don't execute sql when saving an sql buffer
    vim.g.db_ui_execute_on_save = 0

    -- Save queries and db connections to $TMUX_CURRENT_DIR/database_queries if it exists
    local workspace = os.getenv("TMUX_CURRENT_DIR")
    if workspace ~= nil and utils.file_exists(workspace) then
      vim.g.db_ui_save_location = workspace .. "/database_queries"
    end

    -- Position the drawer on the right side of the window
    vim.g.db_ui_win_position = "right"

    -- Don't use neovim's notfication system
    vim.g.db_ui_use_nvim_notify = 0

    augroup("dadbod-ui", { clear = true })
    autocmd("FileType", {
      group = "dadbod-ui",
      pattern = "dbui",
      callback = function()
        -- Unmap these as I use <C-J/K> for navigating windows
        vim.cmd("unmap <buffer> <C-j>")
        vim.cmd("unmap <buffer> <C-k>")

        -- Unmap these as they are annoying
        vim.cmd("unmap <buffer> <C-p>")
        vim.cmd("unmap <buffer> <C-n>")

        vim.keymap.set("n", "<Tab>", "<Plug>(DBUI_SelectLine)", { buffer = 0 })
      end,
    })
    autocmd("FileType", {
      group = "dadbod-ui",
      pattern = { "sql", "mysql", "plsql" },
      callback = function()
        vim.keymap.set(
          "n",
          "<leader>e",
          ":normal mavip<CR><Plug>(DBUI_ExecuteQuery)`a",
          { silent = true, buffer = true, desc = "[E]xecute SQL query under cursor" }
        )
        vim.keymap.set(
          { "v", "x" },
          "<leader>e",
          "ma<Plug>(DBUI_ExecuteQuery)`a",
          { silent = true, buffer = true, desc = "[E]xecute SQL query under cursor" }
        )
      end
    })
    autocmd("FileType", {
      group = "dadbod-ui",
      pattern = "dbout",
      callback = function()
        vim.keymap.set(
          "n",
          "<CR>",
          "<Plug>(DBUI_JumpToForeignKey)",
          { buffer = true, desc = "Jump to foreign key" }
        )
      end
    })
  end
}
