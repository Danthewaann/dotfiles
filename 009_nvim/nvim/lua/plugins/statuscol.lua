return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    local utils = require("custom.utils")
    require("statuscol").setup({
      relculright = true,
      bt_ignore = { "terminal" },
      ft_ignore = utils.ignore_filetypes,
      segments = {
        {
          text = { " " },
          condition = { builtin.not_empty },
          click = "v:lua.ScLa",
        },
        {
          sign = { namespace = { "gitsigns" }, auto = true },
          click = "v:lua.ScSa"
        },
        {
          sign = { namespace = { "diagnostic/signs" }, auto = true },
          click = "v:lua.ScSa"
        },
        {
          sign = { name = { "vimspector", ".*" }, auto = true },
          click = "v:lua.ScSa"
        },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        }
      },
    })
  end,
}
