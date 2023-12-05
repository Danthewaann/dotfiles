return {
    "puremourning/vimspector",
    init = function()
        -- Must define this before loading vimspector
        vim.g.vimspector_enable_mappings = "HUMAN"
        vim.g.vimspector_install_gadgets = { "debugpy", "vscode-node-debug2", "delve" }
        vim.g.vimspector_sign_priority = {
            vimspectorBP = 999,
            vimspectorBPCond = 2,
            vimspectorBPLog = 2,
            vimspectorBPDisabled = 1,
            vimspectorPC = 999,
            vimspectorPCBP = 1001,
            vimspectorCurrentThread = 1000,
            vimspectorCurrentFrame = 1000,
        }
        vim.g.vimspector_enable_winbar = 0
        vim.g.vimspector_code_minwidth = 120
        vim.g.vimspector_sidebar_width = 70
        vim.g.vimspector_bottombar_height = 5
    end,
    config = function()
        vim.api.nvim_create_user_command("VimspectorConfig", function(_)
            vim.cmd(":e ~/.vimspector.json")
        end, { desc = "Edit Vimspector config" })

        vim.keymap.set({ "n", "x" }, "<leader>vi", "<Plug>VimspectorBalloonEval", { desc = "[V]imspector [I]nspect" })
        vim.keymap.set("n", "<leader><F11>", "<Plug>VimspectorUpFrame", { desc = "Vimspector Up Frame" })
        vim.keymap.set("n", "<leader><F12>", "<Plug>VimspectorDownFrame", { desc = "Vimspector Down Frame" })
        vim.keymap.set("n", "<leader>vb", "<Plug>VimspectorBreakpoints", { desc = "[V]imspector [B]reakpoints" })
        vim.keymap.set("n", "<leader>vd", "<Plug>VimspectorDisassemble", { desc = "[V]imspector [D]isassemble" })
        vim.keymap.set("n", "<leader>vc", "<Plug>VimspectorContinue", { desc = "[V]imspector [C]ontinue" })
        vim.keymap.set("n", "<leader>vr", "<Plug>VimspectorRestart", { desc = "[V]imspector [R]estart" })
        vim.keymap.set("n", "<leader>vq", "<cmd>VimspectorReset<CR>", { desc = "[V]imspector [Q]uit" })

        vim.cmd [[
            function! s:CustomiseUI()
                let wins = g:vimspector_session_windows

                call win_gotoid( g:vimspector_session_windows.code )
                let file_extension = expand('%:e')
                nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval

                " Enable keyboard-hover for vars and watches
                call win_gotoid( g:vimspector_session_windows.variables )
                nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval
                nmap <silent><buffer> <Tab> <Enter>
                if file_extension =~# "py"
                    setlocal filetype=python
                elseif file_extension =~# "go"
                    setlocal filetype=go
                endif
                setlocal statuscolumn=

                call win_gotoid( g:vimspector_session_windows.watches )
                nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval
                nmap <silent><buffer> <Tab> <Enter>
                if file_extension =~# "py"
                    setlocal syntax=python
                elseif file_extension =~# "go"
                    setlocal syntax=go
                endif
                setlocal statuscolumn=

                call win_gotoid( g:vimspector_session_windows.stack_trace )
                nmap <silent><buffer> <localleader>o <Plug>VimspectorBalloonEval
                nmap <silent><buffer> <Tab> <Enter>
                if file_extension =~# "py"
                    setlocal filetype=python
                elseif file_extension =~# "go"
                    setlocal filetype=go
                endif
                setlocal statuscolumn=

                let console_win = g:vimspector_session_windows.output
                call win_gotoid( console_win )
                inoremap <silent><buffer> <F5> <C-O>:call vimspector#Continue()<CR>
                inoremap <silent><buffer> <F10> <C-O>:call vimspector#StepOver()<CR>
                inoremap <silent><buffer> <F11> <C-O>:call vimspector#StepInto()<CR>
                inoremap <silent><buffer> <F12> <C-O>:call vimspector#StepOut()<CR>
                setlocal scrolloff=0
                setlocal modifiable
                if file_extension =~# "py"
                    setlocal syntax=python
                elseif file_extension =~# "go"
                    setlocal syntax=go
                endif
            endfunction

            let s:code_resized = v:false

            function! s:OnJumpToFrame() abort
                lua require("custom.utils").unfold()
                let file_extension = expand('%:e')
                if s:code_resized == v:false && file_extension =~# "go"
                    resize+10
                    let s:code_resized = v:true
                endif
            endfunction

            function! s:OnDebugEnd() abort
                let s:code_resized = v:false
            endfunction

            augroup MyVimspectorCustomisation
                autocmd!
                autocmd User VimspectorUICreated call s:CustomiseUI()
                autocmd User VimspectorJumpedToFrame call s:OnJumpToFrame()
                autocmd User VimspectorDebugEnded ++nested call s:OnDebugEnd()
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
