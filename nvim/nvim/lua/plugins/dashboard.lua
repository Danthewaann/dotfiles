return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  config = function()
    ---@diagnostic disable-next-line: param-type-mismatch
    local dir = vim.fn.fnamemodify(vim.loop.cwd(), ":~:.")
    local version = vim.version()
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
        footer = {
          "Version: " .. string.format("%d.%d.%d", version.major, version.minor, version.patch),
        },
      },
    }
  end,
  dependencies = { { "nvim-tree/nvim-web-devicons" } }
}
