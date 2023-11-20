return {
  "echasnovski/mini.starter",
  version = "*",
  config = function()
    local starter = require("mini.starter")
    starter.setup({
      items = {
        starter.sections.recent_files(10, true),
        starter.sections.builtin_actions(),
        starter.sections.telescope(),
      },
      content_hooks = {
        starter.gen_hook.adding_bullet(),
        starter.gen_hook.aligning('center', 'center'),
        starter.gen_hook.indexing('all', { 'Builtin actions' }),
        starter.gen_hook.padding(3, 2),
      },
      silent = true,
    })
  end
}
