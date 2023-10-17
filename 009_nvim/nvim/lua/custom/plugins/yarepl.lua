return {
    'milanglacier/yarepl.nvim',
    config = function ()
        -- below is the default configuration, there's no need to copy paste them if
        -- you are satisfied with the default configuration, just calling
        -- `require('yarepl').setup {}` is sufficient.
        local yarepl = require 'yarepl'

        yarepl.setup {
            -- see `:h buflisted`, whether the REPL buffer should be buflisted.
            buflisted = true,
            -- whether the REPL buffer should be a scratch buffer.
            scratch = true,
            -- the filetype of the REPL buffer created by `yarepl`
            ft = 'REPL',
            -- How yarepl open the REPL window, can be a string or a lua function.
            -- See below example for how to configure this option
            wincmd = function(bufnr, name)
                local width = math.floor(vim.o.columns * 0.4)
                local cmd = "vertical" .. width .. "split"
                vim.cmd(cmd)
                vim.api.nvim_set_current_buf(bufnr)
            end,
            -- The available REPL palattes that `yarepl` can create REPL based on
            metas = {
                make = { cmd = {'make', 'repl'}, formatter = yarepl.formatter.bracketed_pasting },
                ipython = { cmd = {'ipython', '--no-confirm-exit'}, formatter = yarepl.formatter.bracketed_pasting },
                python = { cmd = 'python', formatter = yarepl.formatter.trim_empty_lines },
                bash = { cmd = 'bash', formatter = yarepl.formatter.trim_empty_lines },
                zsh = { cmd = 'zsh', formatter = yarepl.formatter.bracketed_pasting },
            },
            -- when a REPL process exits, should the window associated with those REPLs closed?
            close_on_exit = true,
            -- whether automatically scroll to the bottom of the REPL window after sending
            -- text? This feature would be helpful if you want to ensure that your view
            -- stays updated with the latest REPL output.
            scroll_to_bottom_after_sending = true,
            os = {
                -- Some hacks for Windows. macOS and Linux users can simply ignore
                -- them. The default options are recommended for Windows user.
                windows = {
                    -- Send a final `\r` to the REPL with delay,
                    send_delayed_cr_after_sending = true,
                },
            },
        }

        -- The `run_cmd_with_count` function enables a user to execute a command with
        -- count values in keymaps. This is particularly useful for `yarepl.nvim`,
        -- which heavily uses count values as the identifier for REPL IDs.
        local function run_cmd_with_count(cmd)
            return function()
                vim.cmd(string.format('%d%s', vim.v.count, cmd))
            end
        end

        -- The `partial_cmd_with_count_expr` function enables users to enter partially
        -- complete commands with a count value, and specify where the cursor should be
        -- placed. This function is mainly designed to bind `REPLExec` command into a
        -- keymap.
        local function partial_cmd_with_count_expr(cmd)
            return function()
                -- <C-U> is equivalent to \21, we want to clear the range before next input
                -- to ensure the count is recognized correctly.
                return ':\21' .. vim.v.count .. cmd
            end
        end

        local bufmap = vim.api.nvim_buf_set_keymap
        local autocmd = vim.api.nvim_create_autocmd

        local ft_to_repl = {
            python = 'make',
            sh = 'bash',
            REPL = '',
        }

        autocmd('FileType', {
            pattern = { 'python', 'sh', 'REPL' },
            desc = 'set up REPL keymap',
            callback = function()
                local repl = ft_to_repl[vim.bo.filetype]
                bufmap(0, 'n', '<leader>rs', '', {
                    callback = run_cmd_with_count('REPLStart ' .. repl),
                    desc = 'Start an REPL',
                })
                bufmap(0, 'n', '<leader>rf', '', {
                    callback = run_cmd_with_count 'REPLFocus',
                    desc = 'Focus on REPL',
                })
                bufmap(0, 'n', '<leader>rv', '<CMD>Telescope REPLShow<CR>', {
                    desc = 'View REPLs in telescope',
                })
                bufmap(0, 'n', '<leader>rh', '', {
                    callback = run_cmd_with_count 'REPLHide',
                    desc = 'Hide REPL',
                })
                bufmap(0, 'v', '<leader>sv', '', {
                    callback = run_cmd_with_count 'REPLSendVisual',
                    desc = 'Send visual region to REPL',
                })
                bufmap(0, 'n', '<leader>sl', '', {
                    callback = run_cmd_with_count 'REPLSendLine',
                    desc = 'Send current line to REPL',
                })
                -- `<leader>sap` will send the current paragraph to the
                -- buffer-attached REPL, or REPL 1 if there is no REPL attached.
                -- `2<Leader>sap` will send the paragraph to REPL 2. Note that `ap` is
                -- just an example and can be replaced with any text object or motion.
                bufmap(0, 'n', '<leader>s', '', {
                    callback = run_cmd_with_count 'REPLSendMotion',
                    desc = 'Send motion to REPL',
                })
                bufmap(0, 'n', '<leader>rq', '', {
                    callback = run_cmd_with_count 'REPLClose',
                    desc = 'Quit REPL',
                })
                bufmap(0, 'n', '<leader>rc', '<CMD>REPLCleanup<CR>', {
                    desc = 'Clear REPLs.',
                })
                bufmap(0, 'n', '<leader>rS', '<CMD>REPLSwap<CR>', {
                    desc = 'Swap REPLs.',
                })
                bufmap(0, 'n', '<leader>r?', '', {
                    callback = run_cmd_with_count 'REPLStart',
                    desc = 'Start an REPL from available REPL metas',
                })
                bufmap(0, 'n', '<leader>ra', '<CMD>REPLAttachBufferToREPL<CR>', {
                    desc = 'Attach current buffer to a REPL',
                })
                bufmap(0, 'n', '<leader>rd', '<CMD>REPLDetachBufferToREPL<CR>', {
                    desc = 'Detach current buffer to any REPL',
                })
                -- `3<leader>re df.describe()`: This keymap executes the specified
                -- command in REPL 3.
                bufmap(0, 'n', '<leader>re', '', {
                    callback = partial_cmd_with_count_expr 'REPLExec ',
                    desc = 'Execute command in REPL',
                    expr = true,
                })
            end,
        })
    end
}
