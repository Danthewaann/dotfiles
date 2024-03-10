return {
  "echasnovski/mini.starter",
  version = "*",
  config = function()
    local starter = require("mini.starter")
    local header = function()
      local hour = tonumber(vim.fn.strftime("%H"))
      -- [04:00, 12:00) - morning, [12:00, 20:00) - day, [20:00, 04:00) - evening
      local part_id = math.floor((hour + 4) / 8) + 1
      local day_part = ({ "evening", "morning", "afternoon", "evening" })[part_id]
      local username = "Daniel"

      return ("Good %s, %s"):format(day_part, username)
    end

    starter.setup({
      header = header,
      items = {
        starter.sections.sessions(5, true),
        starter.sections.recent_files(10, true),
        { action = "Telescope find_files", name = "Files",     section = "Actions" },
        { action = require("oil").open,    name = "Browser",   section = "Actions" },
        { action = "Telescope live_grep",  name = "Live grep", section = "Actions" },
        { action = "Telescope oldfiles",   name = "Old files", section = "Actions" },
        starter.sections.builtin_actions(),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning("center", "center"),
        starter.gen_hook.padding(3, 2),
      },
      query_updaters = "BFLOabcdefghijklmnopqrstuvwxyz0123456789_-.",
      silent = true,
    })

    vim.keymap.set("n", "<leader>ms", "<cmd> lua MiniStarter.open()<CR>", { desc = "[M]ini [S]tarter" })
  end
}
