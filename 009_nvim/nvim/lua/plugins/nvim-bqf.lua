return {
  "kevinhwang91/nvim-bqf",
  dependencies = {
    {
      "junegunn/fzf",
      build = function()
        vim.fn["fzf#install"]()
      end
    }
  },
  config = function()
    require("bqf").setup({
      auto_enable = true,
      auto_resize_height = true, -- highly recommended enable
      preview = {
        auto_preview = false,
        show_scroll_bar = false,
        winblend = 0,
        wrap = true,
        buf_label = false,
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
        show_title = false,
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            -- skip file size greater than 100k
            ret = false
          elseif bufname:match("^fugitive://") then
            -- skip fugitive buffer
            ret = false
          end
          return ret
        end
      },
      -- make `drop` and `tab drop` to become preferred
      func_map = {
        drop = "o",
        openc = "O",
        split = "<C-s>",
        tabdrop = "<C-t>",
        -- set to empty string to disable
        tabc = "",
        ptogglemode = "z,",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " }
        }
      }
    })
    vim.keymap.set("n", "]q", function()
      local ok, _ = pcall(vim.cmd, "cnext")
      if not ok then
        ok, _ = pcall(vim.cmd, "cfirst")
        if ok then
          vim.cmd.normal("zz")
        end
      else
        vim.cmd.normal("zz")
      end
    end)
    vim.keymap.set("n", "[q", function()
      local ok, _ = pcall(vim.cmd, "cprevious")
      if not ok then
        ok, _ = pcall(vim.cmd, "clast")
        if ok then
          vim.cmd.normal("zz")
        end
      else
        vim.cmd.normal("zz")
      end
    end)
  end
}
