---@diagnostic disable: missing-fields, param-type-mismatch, missing-parameter
return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      padding = false,
      auto_refresh = false,
      auto_close = false,
      restore = false,
      warn_no_results = false,
      keys = {
        ["<c-x>"] = "jump_split",
        gb = { -- toggle the active view filter
          action = function(view)
            view:filter({ buf = 0 }, { toggle = true })
          end,
          desc = "Toggle Current Buffer Filter",
        },
        s = { -- toggle the severity
          action = function(view)
            local f = view:get_filter("severity")
            local severity = ((f and f.filter.severity or 0) + 1) % 5
            view:filter({ severity = severity }, {
              id = "severity",
              template = "{hl:Title}Filter:{hl} {severity}",
              del = severity == 0,
            })
          end,
          desc = "Toggle Severity Filter",
        },
      }
    })

    vim.keymap.set("n", "<C-j>", function()
      if require("trouble").is_open() == true then
        require("trouble").next({ skip_groups = true, jump = true })
      else
        local ok, _ = pcall(vim.cmd, "cnext")
        if not ok then
          ok, _ = pcall(vim.cmd, "cfirst")
          if ok then
            vim.cmd.normal("zz")
          end
        else
          vim.cmd.normal("zz")
        end
      end
    end, { desc = "Jump to next trouble/qf item" })
    vim.keymap.set("n", "<C-k>", function()
      if require("trouble").is_open() == true then
        require("trouble").prev({ skip_groups = true, jump = true })
      else
        local ok, _ = pcall(vim.cmd, "cprevious")
        if not ok then
          ok, _ = pcall(vim.cmd, "clast")
          if ok then
            vim.cmd.normal("zz")
          end
        else
          vim.cmd.normal("zz")
        end
      end
    end, { desc = "Jump to previous trouble/qf item" })

    vim.keymap.set(
      "n",
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      { desc = "Diagnostics" }
    )
    vim.keymap.set(
      "n",
      "<leader>xs",
      "<cmd>Trouble symbols toggle focus=false win.position=bottom<cr>",
      { desc = "Symbols" }
    )
    vim.keymap.set(
      "n",
      "<leader>xl",
      "<cmd>Trouble lsp toggle focus=false<cr>",
      { desc = "LSP Definitions / references / ..." }
    )
    vim.keymap.set(
      "n",
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      { desc = "Location List" }
    )
    vim.keymap.set(
      "n",
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      { desc = "Quickfix List" }
    )
  end
}
