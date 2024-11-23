return {
  "echasnovski/mini.starter",
  version = "*",
  config = function()
    local utils = require("custom.utils")
    local buf_ui = require("buffer_manager.ui")
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
      autoopen = true,
      header = header,
      items = {
        function()
          if utils.file_exists(".nvim_buffers") then
            return {
              name = "Load buffers from file",
              action = function()
                buf_ui.load_menu_from_file(".nvim_buffers")
                buf_ui.nav_file(1)
              end,
              section = "Load Buffers"
            }
          end

          return {}
        end,
        starter.sections.sessions(5, true),
        starter.sections.recent_files(20, true)
      },
      content_hooks = {
        starter.gen_hook.aligning("center", "center"),
        starter.gen_hook.padding(3, 2),
      },
      query_updaters = "BFLOabcdefghijklmnopqrstuvwxyz0123456789.",
      footer = "",
      silent = true,
    })
  end
}
