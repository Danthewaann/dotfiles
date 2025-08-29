return {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    select = {
      telescope = require("telescope.themes").get_dropdown({ layout_config = { height = 0.4 } })
    },
    input = {
      insert_only = false,
      start_in_insert = false,
      relative = "editor",
      get_config = function(opts)
        if opts.prompt == "New Name: " then
          return {
            relative = "cursor"
          }
        elseif opts.prompt == "Enter branch name" then
          return {
            width = 70
          }
        end
      end
    },
  },
}
