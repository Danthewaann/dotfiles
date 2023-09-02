local npairs = require("nvim-autopairs")
npairs.setup({ map_cp = false })

_G.MUtils= {}

-- Make <CR> confirm an autocomplete selection
-- From: https://github.com/windwp/nvim-autopairs/wiki/Completion-plugin
MUtils.completion_confirm=function()
    if vim.fn["coc#pum#visible"]() ~= 0  then
        return vim.fn["coc#pum#confirm"]()
    else
        return npairs.autopairs_cr()
    end
end

vim.keymap.set("i", "<CR>", "v:lua.MUtils.completion_confirm()", {expr = true , noremap = true})
