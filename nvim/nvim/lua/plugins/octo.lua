return {
  "Danthewaann/octo.nvim",
  branch = "my-fixes",
  keys = {
    { "<leader>op", desc = "[O]cto open [P]R" },
    { "<leader>ov", desc = "[O]cto start or resume PR re[v]iew" },
  },
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("octo").setup({
      picker = "telescope",
      use_local_fs = true,
      reviews = { auto_show_threads = false, focus = "right" },
      ui = {
        use_signcolumn = true, -- show "modified" marks on the sign column
        use_signstatus = true, -- show "modified" marks on the status column
      },
      suppress_missing_scope = { projects_v2 = true },
      enable_builtin = true,
      mappings_disable_default = false,
      mappings = {
        pull_request = {
          list_commits = { lhs = "<localleader>oc", desc = "list PR commits" },
          list_changed_files = { lhs = "<localleader>of", desc = "list PR changed files" },
          show_pr_diff = { lhs = "<localleader>od", desc = "show PR diff" },
        },
        submit_win = {
          close_review_tab = { lhs = "" },
        },
        review_thread = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<M-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<M-k>", desc = "move to next changed file" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<M-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<M-k>", desc = "move to next changed file" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<M-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<M-k>", desc = "move to next changed file" },
        }
      }
    })
    vim.keymap.set("n", "<leader>op", function()
      local buffers = vim.api.nvim_list_bufs()
      for _, buf in ipairs(buffers) do
        local buf_name = vim.api.nvim_buf_get_name(buf)

        if buf_name:match("^octo://") and vim.api.nvim_get_option_value("modified", { buf = buf }) then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
      print("Opening PR...")
      vim.cmd("Octo pr")
    end, { desc = "Open PR for current branch" })
    vim.keymap.set("n", "<leader>ov", function()
      print("Opening review for PR...")
      vim.cmd("Octo review")
    end, { desc = "Start or resume review" })
    vim.keymap.set("n", "<localleader>t", "<cmd>Octo review thread<CR>", { desc = "Show review threads" })
  end
}
