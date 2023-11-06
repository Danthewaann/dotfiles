return {
  "luukvbaal/statuscol.nvim",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      bt_ignore = { "terminal" },
      ft_ignore = { "oil", "Trouble", "fugitive" },
      segments = {
        {
          sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
          click = "v:lua.ScSa",
        },
        {
          sign = { text = { ".*" } },
          click = "v:lua.ScSa",
        },
        {
          text = { builtin.lnumfunc, " " },
          condition = { true, builtin.not_empty },
          click = "v:lua.ScLa",
        },
      },
    })
  end,
}
