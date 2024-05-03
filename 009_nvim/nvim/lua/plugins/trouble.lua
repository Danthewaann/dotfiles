return {
  "folke/trouble.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({
      padding = false,
      auto_close = true,
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
        require("trouble").previous({ skip_groups = true, jump = true })
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

    vim.keymap.set("n", "<leader>q", function()
      require("trouble").toggle()
    end, { desc = "Trouble toggle" })
    vim.keymap.set("n", "<leader>xw", function()
      require("trouble").toggle("workspace_diagnostics")
    end, { desc = "Trouble toggle workspace diagnostics" })
    vim.keymap.set("n", "<leader>xd", function()
      require("trouble").toggle("document_diagnostics")
    end, { desc = "Trouble toggle document diagnostics" })
    vim.keymap.set("n", "<leader>xq", function()
      require("trouble").toggle("quickfix")
    end, { desc = "Trouble toggle quickfix" })
    vim.keymap.set("n", "<leader>xl", function()
      require("trouble").toggle("loclist")
    end, { desc = "Trouble toggle locationlist" })
  end
}
