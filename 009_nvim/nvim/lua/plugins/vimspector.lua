return {
    "puremourning/vimspector",
    init = function()
        -- Must define this before loading vimspector
        vim.g.vimspector_enable_mappings = "HUMAN"
        vim.g.vimspector_install_gadgets = { "debugpy", "vscode-node-debug2", "delve" }
        vim.g.vimspector_sign_priority = {
            vimspectorBP = 999,
            vimspectorBPCond = 999,
            vimspectorBPLog = 999,
            vimspectorBPDisabled = 999,
            vimspectorPC = 999,
            vimspectorPCBP = 1001,
            vimspectorCurrentThread = 1000,
            vimspectorCurrentFrame = 1000,
        }
        vim.g.vimspector_enable_winbar = 0
    end,
    config = function()
        vim.api.nvim_create_user_command("VimspectorConfig", function(_)
            vim.cmd(":e ~/.vimspector.json")
        end, { desc = "Edit Vimspector config" })

        vim.keymap.set("n", "<leader>vi", function()
            local file_extension = vim.fn.expand("%:e")
            vim.fn["vimspector#ShowEvalBalloon"](0)
            vim.defer_fn(function()
                if string.match(file_extension, "py") then
                    vim.treesitter.start(0, "python")
                elseif string.match(file_extension, "go") then
                    vim.treesitter.start(0, "go")
                end

                -- Need to use vimscript to set binds for some reason as using `vim.keymap.set` doesn't work
                vim.cmd("nmap <silent><buffer> <Tab> <Enter>")
            end, 100)
        end, { desc = "[V]imspector [I]nspect" })
        vim.keymap.set("n", "<leader><F5>", "<Plug>VimspectorLaunch", { desc = "Vimspector Launch" })
        vim.keymap.set("n", "<leader><F8>", "<Plug>VimspectorRunToCursor", { desc = "Vimspector Run To Cursor" })
        vim.keymap.set(
            "n",
            "<leader><F9>",
            "<Plug>VimspectorToggleConditionalBreakpoint",
            { desc = "Vimspector Toggle Conditional Breakpoint" }
        )
        vim.keymap.set("n", "<leader><F11>", "<Plug>VimspectorUpFrame", { desc = "Vimspector Up Frame" })
        vim.keymap.set("n", "<leader><F12>", "<Plug>VimspectorDownFrame", { desc = "Vimspector Down Frame" })
        vim.keymap.set("n", "<leader>vb", "<Plug>VimspectorBreakpoints", { desc = "[V]imspector [B]reakpoints" })
        vim.keymap.set("n", "<leader>vd", "<Plug>VimspectorDisassemble", { desc = "[V]imspector [D]isassemble" })
        vim.keymap.set("n", "<leader>vc", "<Plug>VimspectorContinue", { desc = "[V]imspector [C]ontinue" })
        vim.keymap.set("n", "<leader>vs", "<cmd>VimspectorMkSession<CR>", { desc = "[V]imspector [S]ave Session" })
        vim.keymap.set("n", "<leader>vl", "<cmd>VimspectorLoadSession<CR>", { desc = "[V]imspector [L]oad Session" })
        vim.keymap.set("n", "<leader>vr", function()
            -- The delve debugger for go doesn't exit after you finish debugging.
            -- Here we manually navigate to the terminal buffer and invoke a SIGINTERRUPT
            -- before restarting the debugger so we can reuse the buffer.
            local buflist = vim.fn.tabpagebuflist()
            for _, buf in ipairs(buflist) do
                local ok, chan_id = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
                if ok then
                    vim.fn.jobstop(chan_id)
                    -- I don't know why I need this sleep here. Having this sleep here seems to allow the
                    -- terminal to properly cleanup before vimspector re-uses it.
                    vim.cmd.sleep("100m")
                end
            end

            vim.fn["vimspector#Restart"]()
        end, { desc = "[V]imspector [R]estart" })
        vim.keymap.set("n", "<leader>vq", "<cmd>VimspectorReset<CR>", { desc = "[V]imspector [Q]uit" })

        vim.cmd [[
            function! s:CustomiseUI()
                let wins = g:vimspector_session_windows

                let s:session_name = vimspector#GetSessionName()
                exe "LualineRenameTab [" . s:session_name . "]"

                call win_gotoid( g:vimspector_session_windows.code )
                let file_extension = expand('%:e')

                " Enable keyboard-hover for vars and watches
                call win_gotoid( g:vimspector_session_windows.variables )
                nmap <silent><buffer> <Tab> <Enter>
                if file_extension =~# "py"
                    lua vim.treesitter.start(0, "python")
                elseif file_extension =~# "go"
                    lua vim.treesitter.start(0, "go")
                endif

                call win_gotoid( g:vimspector_session_windows.watches )
                nmap <silent><buffer> <Tab> <Enter>
                if file_extension =~# "py"
                    lua vim.treesitter.start(0, "python")
                elseif file_extension =~# "go"
                    lua vim.treesitter.start(0, "go")
                endif

                call win_gotoid( g:vimspector_session_windows.stack_trace )
                nmap <silent><buffer> <Tab> <Enter>
                lua vim.treesitter.stop()

                let console_win = g:vimspector_session_windows.output
                call win_gotoid( console_win )
                inoremap <silent><buffer> <F5> <C-O>:call vimspector#Continue()<CR>
                inoremap <silent><buffer> <F10> <C-O>:call vimspector#StepOver()<CR>
                inoremap <silent><buffer> <F11> <C-O>:call vimspector#StepInto()<CR>
                inoremap <silent><buffer> <F12> <C-O>:call vimspector#StepOut()<CR>
                setlocal scrolloff=0
                setlocal modifiable
                lua vim.treesitter.stop()
            endfunction

            function! s:OnJumpToFrame() abort
                lua require("custom.utils").unfold()
            endfunction

            sign define vimspectorBP            text=● texthl=Special
            sign define vimspectorBPCond        text=◆ texthl=Special
            sign define vimspectorBPLog         text=◆ texthl=Special
            sign define vimspectorBPDisabled    text=● texthl=LineNr
            sign define vimspectorPC            text=▶ texthl=Special linehl=CursorLine
            sign define vimspectorPCBP          text=●▶  texthl=Special linehl=CursorLine
            sign define vimspectorNonActivePC   linehl=DiffAdd
            sign define vimspectorCurrentThread text=▶   texthl=Special linehl=CursorLine
            sign define vimspectorCurrentFrame  text=▶   texthl=Special    linehl=CursorLine

            augroup MyVimspectorCustomisation
                autocmd!
                autocmd User VimspectorUICreated call s:CustomiseUI()
                autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
            augroup END

            " Allow for command history in VimspectorPrompt
            "
            " from https://github.com/puremourning/vimspector/issues/52#issuecomment-699027787
            augroup vimspector_command_history
              autocmd!
              autocmd FileType VimspectorPrompt call InitializeVimspectorCommandHistory()
            augroup end

            function! InitializeVimspectorCommandHistory()
              if !exists('b:vimspector_command_history')
                  inoremap <silent> <buffer> <CR> <C-o>:call VimspectorCommandHistoryAdd()<CR>
                  inoremap <silent> <buffer> <C-p> <C-o>:call VimspectorCommandHistoryUp()<CR>
                  inoremap <silent> <buffer> <C-n> <C-o>:call VimspectorCommandHistoryDown()<CR>
                  inoremap <silent> <buffer> <C-c> <C-c>dd:startinsert<CR>
                  let b:vimspector_command_history = []
                  let b:vimspector_command_history_pos = 0
              endif
            endfunction

            function! VimspectorCommandHistoryAdd()
              let line = trim(getline('.'))
              if line != '>'
                  call add(b:vimspector_command_history, line)
                  let b:vimspector_command_history_pos = len(b:vimspector_command_history)
              endif
              call feedkeys("\<CR>i", 'tn')
            endfunction

            function! VimspectorCommandHistoryUp()
              if len(b:vimspector_command_history) == 0 || b:vimspector_command_history_pos == 0
                  return
              endif
              call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
              call feedkeys("\<C-o>A", 'tn')
              let b:vimspector_command_history_pos = b:vimspector_command_history_pos - 1
            endfunction

            function! VimspectorCommandHistoryDown()
              if b:vimspector_command_history_pos == len(b:vimspector_command_history)
                  return
              endif
              call setline('.', b:vimspector_command_history[b:vimspector_command_history_pos - 1])
              call feedkeys("\<C-o>A", 'tn')
              let b:vimspector_command_history_pos = b:vimspector_command_history_pos + 1
            endfunction
        ]]
    end
}
