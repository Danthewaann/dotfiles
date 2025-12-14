return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    require("dashboard").setup {
      config = {
        header = {
          " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
          " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
          " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
          " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
        },
        week_header = { enable = false },
        shortcut = {},
        project = { enable = false },
        mru = { enable = false },
        footer = {},
      },
      hide = { statusline = false, tabline = false, winbar = false }
    }
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } }
}
