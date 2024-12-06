return {
  "pwntester/octo.nvim",
  event = "VeryLazy",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
    local autocmd = vim.api.nvim_create_autocmd -- Create autocommand

    vim.treesitter.language.register("markdown", "octo")

    require("octo").setup({
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        review_thread = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        }
      }
    })

    augroup("octo", { clear = true })
    autocmd("FileType", {
      group = "octo",
      pattern = "octo_panel",
      callback = function()
        vim.keymap.set(
          "n",
          "<leader>vc",
          "<cmd> Octo review commit<CR>",
          { buffer = true, desc = "review commit" }
        )
      end,
    })

    vim.keymap.set("n", "<leader>gh", function()
      local commands = {
        ["1. Open PR"] = function()
          local obj = vim.system({ "gh", "prv" }):wait()
          if obj.code ~= 0 then
            M.print_err(obj.stderr)
            return
          end
        end,
        ["2. Open Repository"] = function()
          local obj = vim.system({ "gh", "rv" }):wait()
          if obj.code ~= 0 then
            M.print_err(obj.stderr)
            return
          end
        end,
      }

      local keys = vim.tbl_keys(commands)
      table.sort(keys)

      vim.ui.select(
        keys,
        { prompt = "Github" },
        function(choice)
          for key, value in pairs(commands) do
            if choice == key then
              value()
              return
            end
          end
        end
      )
    end, { desc = "[G]it[H]ub commands" })
  end
}
