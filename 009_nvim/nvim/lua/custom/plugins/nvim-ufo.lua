return {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    config = function ()
        local ftMap = {
            python = true,
            go = true,
            lua = true,
            ruby = true,
            markdown = true,
            sh = true,
            yaml = true,
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
                -- if you prefer treesitter provider rather than lsp
                -- refer to ./doc/example.lua for detail
                if ftMap[filetype] then
                    return {'treesitter', 'indent'}
                end

                return ''
            end
        })

        vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
        vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)

        -- Automatically close all folds when opening a file
        -- From: https://github.com/kevinhwang91/nvim-ufo/issues/89#issuecomment-1286250241
        -- And: https://github.com/kevinhwang91/nvim-ufo/issues/83#issuecomment-1259233578
        local function applyFoldsAndThenCloseAllFolds(bufnr, providerName)
            require('async')(function()
                bufnr = bufnr or vim.api.nvim_get_current_buf()
                -- make sure buffer is attached
                require('ufo').attach(bufnr)
                -- getFolds return Promise if providerName == 'lsp'
                local ok, ranges = pcall(await, require("ufo").getFolds(bufnr, providerName))
                if ok and ranges then
                    ok = require("ufo").applyFolds(bufnr, ranges)
                    if ok then
                        require("ufo").closeAllFolds()
                    end
                else
                    -- fallback to indent folding
                    ranges = await(require("ufo").getFolds(bufnr, "indent"))
                    ok = require("ufo").applyFolds(bufnr, ranges)
                    if ok then
                        require("ufo").closeAllFolds()
                    end
                end
            end)
        end

        vim.api.nvim_create_autocmd('BufRead', {
            pattern = '*',
            callback = function(e)
                local filetype = vim.fn.getbufvar(e.buf, '&filetype')
                if ftMap[filetype] then
                    applyFoldsAndThenCloseAllFolds(e.buf, 'treesitter')
                end
            end
        })
    end
}
