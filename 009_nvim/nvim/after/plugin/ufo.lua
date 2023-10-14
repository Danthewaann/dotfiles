local ftMap = {
    vim = 'indent',
    python = {'indent'},
    git = ''
}
require('ufo').setup({
    open_fold_hl_timeout = 150,
    close_fold_kinds = {'imports', 'comment'},
    preview = {
        win_config = {
            border = {'', '─', '', '', '', '─', '', ''},
            winhighlight = 'Normal:Folded',
            winblend = 0
        },
        mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
        }
    },
    provider_selector = function(bufnr, filetype, buftype)
        -- if you prefer treesitter provider rather than lsp,
        -- return ftMap[filetype] or {'treesitter', 'indent'}
        return {'treesitter', 'indent'}

        -- refer to ./doc/example.lua for detail
    end
})

vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
vim.keymap.set('n', 'K', function()
    local winid = require('ufo').peekFoldedLinesUnderCursor()
    if not winid then
        -- choose one of coc.nvim and nvim lsp
        vim.fn.CocActionAsync('definitionHover') -- coc.nvim
    end
end)

-- Automatically close all folds when opening a file
-- From: https://github.com/kevinhwang91/nvim-ufo/issues/89#issuecomment-1286250241
local function applyFoldsAndThenCloseAllFolds(bufnr, providerName)
    require('async')(function()
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        -- make sure buffer is attached
        require('ufo').attach(bufnr)
        -- getFolds return Promise if providerName == 'lsp'
        local ranges = await(require('ufo').getFolds(bufnr, providerName))
        local ok = require('ufo').applyFolds(bufnr, ranges)
        if ok then
            require('ufo').closeAllFolds()
        end
    end)
end

vim.api.nvim_create_autocmd('BufRead', {
    pattern = '*',
    callback = function(e)
        applyFoldsAndThenCloseAllFolds(e.buf, 'treesitter')
    end
})
