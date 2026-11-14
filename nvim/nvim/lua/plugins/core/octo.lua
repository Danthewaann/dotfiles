return {
  "pwntester/octo.nvim",
  cmd = {"Octo"},
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local use_local_fs = true
    local pr_is_fork = os.getenv("OCTO_PR_IS_FORK")
    if pr_is_fork == "true" then
      use_local_fs = false
    end

    require("octo").setup({
      picker = "snacks",
      use_local_fs = use_local_fs,
      reviews = { auto_show_threads = true, show_virtual_text = false, focus = "right" },
      ui = {
        use_signcolumn = true, -- show "modified" marks on the sign column
        use_signstatus = true, -- show "modified" marks on the status column
      },
      suppress_missing_scope = { projects_v2 = true },
      enable_builtin = true,
      mappings_disable_default = false,
      mappings = {
        pull_request = {
          review = { lhs = "<localleader>vs" },
          review_start = { lhs = "" },
          review_resume = { lhs = "" },
        },
        submit_win = {
          close_review_tab = { lhs = "" },
        },
        review_thread = {
          close_review_tab = { lhs = "" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
        }
      }
    })
  end
}
