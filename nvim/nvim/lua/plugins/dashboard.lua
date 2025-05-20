return {
  "Danthewaann/dashboard-nvim",
  event = "VimEnter",
  config = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local dir = vim.fn.fnamemodify(vim.loop.cwd(), ":~:.")
    require("dashboard").setup {
      config = {
        header = {
          "",
          " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
          " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
          " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
          " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
          " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
          " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
          "",
          "Current dir: " .. dir,
        },
        week_header = { enable = false },
        shortcut = {},
        project = { enable = false },
        mru = { enable = false },
        footer = {},
      },
    }
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } }
}
