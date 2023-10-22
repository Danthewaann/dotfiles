return {
  "stevearc/dressing.nvim",
  opts = {
    input = {
      insert_only = false,
      start_in_insert = true,
      relative = "editor",
    },
    override = function(config)
      print(config)
      return config
    end,
  },
}
