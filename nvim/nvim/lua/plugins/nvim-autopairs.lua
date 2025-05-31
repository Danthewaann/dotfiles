return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    npairs.setup()

    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")

    -- Enable code fence pairs in octo and codecompanion buffers like
    --
    -- This was copied from the source code in nvim-autopairs
    npairs.add_rule(Rule("```", "```", { "octo", "codecompanion" }):with_pair(cond.not_before_char("`", 3)))
    npairs.add_rule(Rule("```.*$", "```", { "octo", "codecompanion" }):only_cr():use_regex(true))
  end,
}
