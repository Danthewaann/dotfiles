return {
  "nvim-mini/mini.ai",
  version = "*",
  config = function()
    local gen_ai_spec = require("mini.extra").gen_ai_spec
    require("mini.ai").setup({
      n_lines = 500,
      custom_textobjects = {
        B = gen_ai_spec.buffer(),
        D = gen_ai_spec.diagnostic(),
        I = gen_ai_spec.indent(),
        L = gen_ai_spec.line(),
        N = gen_ai_spec.number(),
      },
    })
  end
}
