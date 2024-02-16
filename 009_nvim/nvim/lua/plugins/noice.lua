return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      routes = {
        -- Show messages using mini
        -- Kinds from: https://github.com/folke/noice.nvim/wiki/A-Guide-to-Messages
        {
          view = "mini",
          filter = {
            event = "msg_show",
            kind = "",
          },
        },
        {
          view = "split",
          filter = {
            event = "msg_show",
            kind = "echo",
          },
        },
        {
          view = "split",
          filter = {
            event = "msg_show",
            kind = "echomsg",
          },
        },
        {
          view = "split",
          filter = {
            event = "msg_show",
            kind = "echoerr",
          },
        },
        {
          view = "split",
          filter = {
            event = "msg_show",
            kind = "emsg",
          },
        },
        {
          view = "split",
          filter = {
            event = "msg_show",
            kind = "wmsg",
          },
        },
      },
      lsp = {
        progress = {
          enabled = false
        },
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = false,      -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
      cmdline = {
        view = "cmdline"
      },
      popupmenu = {
        backend = "cmp"
      },
      smart_move = {
        enabled = false,
      },
    })

    vim.keymap.set("n", "<leader>n", "<cmd> Noice<CR>", { desc = "Open [N]oice messages" })
  end
}
