return {
    'tpope/vim-obsession',
    'tpope/vim-unimpaired',
    'tpope/vim-abolish',
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'tpope/vim-dadbod',
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        -- See `:help lualine.txt`
        config = function ()
            local winbar_filename_config = {
                'filename',
                file_status = true,      -- Displays file status (readonly status, modified status)
                newfile_status = true,  -- Display new file status (new file means no write after created)
                path = 1,                -- 0: Just the filename
                -- 1: Relative path
                -- 2: Absolute path
                -- 3: Absolute path, with tilde as the home directory
                -- 4: Filename and parent dir, with tilde as the home directory
                fmt = function(result, context)
                    -- Just output the terminal command if this is a terminal job
                    if(string.match(result, "term:.*:.*")) then
                        local t = {}
                        for i in string.gmatch(result, "([^:]*)") do
                            t[#t + 1] = i
                        end
                        -- Remove the term path and port to only include the make command in the tabline 
                        return string.gsub(string.sub(table.concat(t, ":", 4), 2, -5), ":::", "::")
                    elseif(string.match(result, "t//.*:.*")) then
                        local t = {}
                        for i in string.gmatch(result, "([^:]*)") do
                            t[#t + 1] = i
                        end
                        -- Remove the term path and port to only include the make command in the tabline 
                        return string.gsub(string.sub(table.concat(t, ":", 3), 1, -5), ":::", "::")
                    end
                    return result
                end,

                shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
                -- for other components. (terrible name, any suggestions?)
                symbols = {
                    modified = '[+]',      -- Text to show when the file is modified.
                    readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
                    unnamed = '', -- Text to show for unnamed buffers.
                    newfile = '',     -- Text to show for newly created file before first write
                }
            }

            local winbar_filetype_config = {
                'filetype',
                colored = true,   -- Displays filetype icon in color if set to true
                icon_only = true, -- Display only an icon for filetype
                icon = { align = 'right' }, -- Display filetype icon on the right hand side
                -- icon =    {'X', align='right'}
                -- Icon string ^ in table is ignored in filetype component
            }

            require('lualine').setup({
                options = {
                    component_separators = '',
                    section_separators = { left = '', right = '' },
                    ignore_focus = { "NvimTree", "dbui", "undotree", "TelescopePrompt"},
                    globalstatus = true,
                    disabled_filetypes = {
                        winbar = {
                            "qf",
                            "fugitive",
                            "fugitiveblame",
                            "dbui",
                            "NvimTree",
                            "undotree",
                            "gitcommit",
                            "GV",
                            "packer",
                            "list",
                            "help",
                            "spectre_panel",
                            "dbout",
                            "DiffviewFiles",
                            "DiffviewFileHistory"
                        }
                    },
                },
                extensions = { 'fugitive', 'nvim-tree', 'quickfix' },
                winbar = {
                    lualine_a = {},
                    lualine_b = {winbar_filetype_config},
                    lualine_c = {winbar_filename_config},
                    lualine_x = {'diagnostics'},
                    lualine_y = {'diff'},
                    lualine_z = {}
                },
                inactive_winbar = {
                    lualine_a = {},
                    lualine_b = {winbar_filetype_config},
                    lualine_c = {winbar_filename_config},
                    lualine_x = {'diagnostics'},
                    lualine_y = {'diff'},
                    lualine_z = {}
                },
                sections = {
                    lualine_b = {'branch'},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {'progress'},
                    lualine_z = {'location'}
                },
                inactive_sections = {
                    lualine_c = {}
                }
            })
        end
    },
    'kristijanhusak/vim-dadbod-ui',
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            vim.keymap.set("n", "<leader>k", function() require("treesitter-context").go_to_context() end, { silent = true })
        end
    },
    'mbbill/undotree',
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            local function my_on_attach(bufnr)
                local api = require("nvim-tree.api")

                local function opts(desc)
                    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
                end

                -- default mappings
                api.config.mappings.default_on_attach(bufnr)

                -- custom mappings
                vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
            end

            require("nvim-tree").setup({
                on_attach = my_on_attach,
                git = {
                    enable = true,
                    ignore = false,
                },
                view = {
                    width = 50,
                    side = "right"
                },
                renderer = {
                    add_trailing = true,
                    full_name = true,
                    root_folder_label = false
                },
                tab = {
                    sync = {
                        open = true,
                        close = true

                    }
                },
            })

            vim.keymap.set("n", "<C-n>", "<cmd> silent NvimTreeToggle<CR>")
            vim.keymap.set("n", "<leader>nf", "<cmd> silent NvimTreeFindFile<CR>")
        end
    },
    {
        'windwp/nvim-autopairs',
        commit = 'defad64afbf19381fe31488a7582bbac421d6e38',
        event = 'InsertEnter',
        config = function()
            require("nvim-autopairs").setup({})
            local cmp = require("cmp")
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local ts_utils = require("nvim-treesitter.ts_utils")

            local ts_node_func_parens_disabled = {
                -- ecma
                named_imports = true,
                -- rust
                use_declaration = true,
            }

            local default_handler = cmp_autopairs.filetypes["*"]["("].handler
            cmp_autopairs.filetypes["*"]["("].handler = function(char, item, bufnr, rules, commit_character)
                local node_type = ts_utils.get_node_at_cursor():type()
                if ts_node_func_parens_disabled[node_type] then
                    if item.data then
                        item.data.funcParensDisabled = true
                    else
                        char = ""
                    end
                end
                default_handler(char, item, bufnr, rules, commit_character)
            end

            cmp.event:on(
                "confirm_done",
                cmp_autopairs.on_confirm_done({
                    sh = false,
                })
            )
        end
    },
    {
        'akinsho/bufferline.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            local bufferline = require('bufferline')

            local fg_colour_inactive = '#abb2bf'
            local bg_colour_inactive = '#3b3f4c'

            local fg_colour_active = '#282c34'
            local bg_colour_active = '#98c379'

            local fg_colour = '#31353f'
            local bg_colour = '#31353f'

            local onedark_highlights = {
                fill = {
                    fg = fg_colour_inactive,
                    bg = bg_colour,
                },
                background = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                tab = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                tab_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active
                },
                tab_separator = {
                    fg = fg_colour_active,
                    bg = bg_colour_inactive,
                },
                tab_separator_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                },
                tab_close = {
                    fg = fg_colour_inactive,
                    bg = bg_colour,
                },
                close_button = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                close_button_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                close_button_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active
                },
                buffer_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                buffer_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                numbers = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                numbers_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                numbers_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                diagnostic = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                diagnostic_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                diagnostic_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                hint = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                hint_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                hint_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                hint_diagnostic = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                hint_diagnostic_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                hint_diagnostic_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                info = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                info_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                info_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                info_diagnostic = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                info_diagnostic_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                info_diagnostic_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                warning = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                warning_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                warning_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                warning_diagnostic = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                warning_diagnostic_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                warning_diagnostic_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                error = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                error_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                error_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                error_diagnostic = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                error_diagnostic_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                error_diagnostic_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                modified = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                modified_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                modified_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active
                },
                duplicate = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                    italic = true
                },
                duplicate_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                    italic = true
                },
                duplicate_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    italic = true,
                },
                separator = {
                    fg = fg_colour,
                    bg = bg_colour_inactive,
                },
                separator_visible = {
                    fg = fg_colour,
                    bg = bg_colour_inactive,
                },
                separator_selected = {
                    fg = fg_colour,
                    bg = bg_colour_active
                },
                indicator_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                },
                indicator_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active
                },
                pick = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                    bold = true,
                    italic = true,
                },
                pick_visible = {
                    fg = fg_colour_inactive,
                    bg = bg_colour_inactive,
                    bold = true,
                    italic = true,
                },
                pick_selected = {
                    fg = fg_colour_active,
                    bg = bg_colour_active,
                    bold = true,
                    italic = true,
                },
                offset_separator = {
                    fg = fg_colour,
                    bg = bg_colour,
                },
            }

            local onedark_minimal_highlights = {
                fill = {
                    fg = fg_colour_inactive,
                    bg = bg_colour,
                },
                tab_close = {
                    fg = fg_colour_inactive,
                    bg = bg_colour,
                },
                offset_separator = {
                    fg = fg_colour,
                    bg = bg_colour,
                },
            }

            bufferline.setup({
                options = {
                    style_preset = bufferline.style_preset.minimal,
                    separator_style = {"", ""},
                    mode = "tabs", -- set to "tabs" to only show tabpages instead
                    themable = false, -- allows highlight groups to be overriden i.e. sets highlights as default
                    numbers = "ordinal",
                    close_command = "bdelete! %d",       -- can be a string | function, | false see "Mouse actions"
                    right_mouse_command = "bdelete! %d", -- can be a string | function | false, see "Mouse actions"
                    left_mouse_command = "buffer %d",    -- can be a string | function, | false see "Mouse actions"
                    middle_mouse_command = nil,          -- can be a string | function, | false see "Mouse actions"
                    indicator = {
                        style = 'none',
                    },
                    buffer_close_icon = '',
                    modified_icon = '',
                    close_icon = '',
                    left_trunc_marker = '',
                    right_trunc_marker = '',
                    --- name_formatter can be used to change the buffer's label in the bufferline.
                    --- Please note some names can/will break the
                    --- bufferline so use this at your discretion knowing that it has
                    --- some limitations that will *NOT* be fixed.
                    name_formatter = function(buf)  -- buf contains:
                        -- name                | str        | the basename of the active file
                        -- path                | str        | the full path of the active file
                        -- bufnr (buffer only) | int        | the number of the active buffer
                        -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
                        -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
                        --
                        -- Just output the terminal command if this is a terminal job
                        if(string.match(buf.path, "term:.*:.*")) then
                            local t = {}
                            for i in string.gmatch(buf.path, "([^:]+)") do
                                t[#t + 1] = i
                            end
                            -- Remove the term path and port to only include the make command in the tabline 
                            return unpack(t, 3)
                        elseif(string.match(buf.path, "--follow") or string.match(buf.path, "-L")) then
                            return string.format("[Git log] %s", buf.name)
                        elseif(string.match(buf.path, "--graph")) then
                            return "[Git log]"
                        elseif(string.match(buf.path, "DiffviewFilePanel")) then
                            return "Diff View"
                        end
                    end,
                    -- NOTE: this will be called a lot so don't do any heavy processing here
                    custom_filter = function(buf_number, buf_numbers)
                        -- filter out filetypes you don't want to see
                        local file_type = vim.bo[buf_number].filetype
                        if(file_type == "fugitive" or file_type == "NvimTree" or file_type == "dbui" or file_type == "qf" or file_type == "undotree") then
                            return false
                        end
                        -- -- filter out by buffer name
                        -- if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
                        --     return true
                        -- end
                        -- -- filter out based on arbitrary rules
                        -- -- e.g. filter out vim wiki buffer from tabline in your work repo
                        -- if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
                        --     return true
                        -- end
                        -- -- filter out by it's index number in list (don't show first buffer)
                        -- if buf_numbers[1] ~= buf_number then
                        --     return true
                        -- end
                    end,
                    max_name_length = 25,
                    max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
                    truncate_names = true, -- whether or not tab names should be truncated
                    tab_size = 0,
                    diagnostics = "coc",
                    diagnostics_update_in_insert = true,
                    --- count is an integer representing total count of errors
                    --- level is a string "error" | "warning"
                    --- this should return a string
                    --- Don't get too fancy as this function will be executed a lot
                    diagnostics_indicator = function(count, level)
                        local icon = level:match("error") and " " or ""
                        return icon
                    end,
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true
                        },
                        {
                            filetype = "dbui",
                            text = "DB Explorer",
                            text_align = "left",
                            separator = true
                        },
                        {
                            filetype = "undotree",
                            text = "Undotree",
                            text_align = "left",
                            separator = true
                        },
                        {
                            filetype = "DiffviewFiles",
                            text = "Diff View",
                            text_align = "left",
                            separator = true
                        }
                    },
                    show_buffer_icons = true, -- disable filetype icons for buffers
                    show_duplicate_prefix = false, -- whether to show duplicate buffer prefix
                    color_icons = true, -- whether or not to add the filetype icon highlights
                    always_show_bufferline = false,
                }
            })
        end
    },
    {
        'nvim-pack/nvim-spectre',
        config = function()
            local spectre = require("spectre")

            vim.keymap.set('n', '<leader>gs', spectre.open, { desc = "Open Spectre" })
            vim.keymap.set('n', '<leader>sw', function () spectre.open_visual({ select_word=true }) end, { desc = "Search current word" })
            vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = "Search current word" })
        end
    },
    {
        'chrishrb/gx.nvim',
        config = function ()
            local function file_exists(name)
                local f = io.open(name, "r")
                return f ~= nil and io.close(f)
            end

            local browser_app = ""
            local browser_args = {}

            if (file_exists("/proc/sys/fs/binfmt_misc/WSLInterop")) then
                browser_app = "powershell.exe"
                browser_args = { "start explorer.exe" }
            elseif (jit.os == "OSX") then
                browser_app = "open"
                browser_args = { "--background" }
            else
                browser_app = "xdg-open"
                browser_args = {}
            end

            require("gx").setup({
                open_browser_app = browser_app, -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
                open_browser_args = browser_args, -- specify any arguments, such as --background for macOS' "open".
                handlers = {
                    plugin = true, -- open plugin links in lua (e.g. packer, lazy, ..)
                    github = true, -- open github issues
                    brewfile = true, -- open Homebrew formulaes and casks
                    package_json = true, -- open dependencies from package.json
                    search = true, -- search the web/selection on the web if nothing else is found
                },
                handler_options = {
                    search_engine = "google", -- you can select between google, bing and duckduckgo
                }
            })
        end
    },
    'gelguy/wilder.nvim',
    {
        'sindrets/diffview.nvim',
        config = function ()
            local actions = require("diffview.actions")

            require("diffview").setup({
                diff_binaries = false,    -- Show diffs for binaries
                enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
                git_cmd = { "git" },      -- The git executable followed by default args.
                hg_cmd = { "hg" },        -- The hg executable followed by default args.
                use_icons = true,         -- Requires nvim-web-devicons
                show_help_hints = true,   -- Show hints for how to open the help panel
                watch_index = true,       -- Update views and index buffers when the git index changes.
                icons = {                 -- Only applies when use_icons is true.
                    folder_closed = "",
                    folder_open = "",
                },
                signs = {
                    fold_closed = "",
                    fold_open = "",
                    done = "✓",
                },
                view = {
                    -- Configure the layout and behavior of different types of views.
                    -- Available layouts:
                    --  'diff1_plain'
                    --    |'diff2_horizontal'
                    --    |'diff2_vertical'
                    --    |'diff3_horizontal'
                    --    |'diff3_vertical'
                    --    |'diff3_mixed'
                    --    |'diff4_mixed'
                    -- For more info, see ':h diffview-config-view.x.layout'.
                    default = {
                        -- Config for changed files, and staged files in diff views.
                        layout = "diff2_horizontal",
                        winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
                    },
                    merge_tool = {
                        -- Config for conflicted files in diff views during a merge or rebase.
                        layout = "diff3_horizontal",
                        disable_diagnostics = true,   -- Temporarily disable diagnostics for conflict buffers while in the view.
                        winbar_info = true,           -- See ':h diffview-config-view.x.winbar_info'
                    },
                    file_history = {
                        -- Config for changed files in file history views.
                        layout = "diff2_horizontal",
                        winbar_info = false,          -- See ':h diffview-config-view.x.winbar_info'
                    },
                },
                file_panel = {
                    listing_style = "tree",             -- One of 'list' or 'tree'
                    tree_options = {                    -- Only applies when listing_style is 'tree'
                        flatten_dirs = true,              -- Flatten dirs that only contain one single dir
                        folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
                    },
                    win_config = {                      -- See ':h diffview-config-win_config'
                        position = "left",
                        width = 35,
                        win_opts = {}
                    },
                },
                file_history_panel = {
                    log_options = {   -- See ':h diffview-config-log_options'
                        git = {
                            single_file = {
                                diff_merges = "combined",
                            },
                            multi_file = {
                                diff_merges = "first-parent",
                            },
                        },
                        hg = {
                            single_file = {},
                            multi_file = {},
                        },
                    },
                    win_config = {    -- See ':h diffview-config-win_config'
                        position = "bottom",
                        height = 16,
                        win_opts = {}
                    },
                },
                commit_log_panel = {
                    win_config = {   -- See ':h diffview-config-win_config'
                        win_opts = {},
                    }
                },
                default_args = {    -- Default args prepended to the arg-list for the listed commands
                    DiffviewOpen = {},
                    DiffviewFileHistory = {},
                },
                hooks = {},         -- See ':h diffview-config-hooks'
                keymaps = {
                    disable_defaults = false, -- Disable the default keymaps
                    view = {
                        -- The `view` bindings are active in the diff buffers, only when the current
                        -- tabpage is a Diffview.
                        { "n", "<tab>",       actions.select_next_entry,              { desc = "Open the diff for the next file" } },
                        { "n", "<s-tab>",     actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
                        { "n", "gf",          actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
                        { "n", "<C-w><C-f>",  actions.goto_file_split,                { desc = "Open the file in a new split" } },
                        { "n", "<C-w>gf",     actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
                        { "n", "<leader>e",   actions.focus_files,                    { desc = "Bring focus to the file panel" } },
                        { "n", "<leader>b",   actions.toggle_files,                   { desc = "Toggle the file panel." } },
                        { "n", "g<C-x>",      actions.cycle_layout,                   { desc = "Cycle through available layouts." } },
                        { "n", "[x",          actions.prev_conflict,                  { desc = "In the merge-tool: jump to the previous conflict" } },
                        { "n", "]x",          actions.next_conflict,                  { desc = "In the merge-tool: jump to the next conflict" } },
                        { "n", "<leader>co",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
                        { "n", "<leader>ct",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
                        { "n", "<leader>cb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
                        { "n", "<leader>ca",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
                        { "n", "dx",          actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
                        { "n", "<leader>cO",  actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
                        { "n", "<leader>cT",  actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
                        { "n", "<leader>cB",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
                        { "n", "<leader>cA",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
                        { "n", "dX",          actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
                    },
                    diff1 = {
                        -- Mappings in single window diff layouts
                        { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open the help panel" } },
                    },
                    diff2 = {
                        -- Mappings in 2-way diff layouts
                        { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open the help panel" } },
                    },
                    diff3 = {
                        -- Mappings in 3-way diff layouts
                        { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
                        { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
                        { "n",          "g?",   actions.help({ "view", "diff3" }),  { desc = "Open the help panel" } },
                    },
                    diff4 = {
                        -- Mappings in 4-way diff layouts
                        { { "n", "x" }, "1do",  actions.diffget("base"),            { desc = "Obtain the diff hunk from the BASE version of the file" } },
                        { { "n", "x" }, "2do",  actions.diffget("ours"),            { desc = "Obtain the diff hunk from the OURS version of the file" } },
                        { { "n", "x" }, "3do",  actions.diffget("theirs"),          { desc = "Obtain the diff hunk from the THEIRS version of the file" } },
                        { "n",          "g?",   actions.help({ "view", "diff4" }),  { desc = "Open the help panel" } },
                    },
                    file_panel = {
                        { "n", "j",              actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
                        { "n", "<down>",         actions.next_entry,                     { desc = "Bring the cursor to the next file entry" } },
                        { "n", "k",              actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
                        { "n", "<up>",           actions.prev_entry,                     { desc = "Bring the cursor to the previous file entry" } },
                        { "n", "<cr>",           actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
                        { "n", "o",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
                        { "n", "l",              actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
                        { "n", "<2-LeftMouse>",  actions.select_entry,                   { desc = "Open the diff for the selected entry" } },
                        { "n", "-",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
                        { "n", "s",              actions.toggle_stage_entry,             { desc = "Stage / unstage the selected entry" } },
                        { "n", "S",              actions.stage_all,                      { desc = "Stage all entries" } },
                        { "n", "U",              actions.unstage_all,                    { desc = "Unstage all entries" } },
                        { "n", "X",              actions.restore_entry,                  { desc = "Restore entry to the state on the left side" } },
                        { "n", "L",              actions.open_commit_log,                { desc = "Open the commit log panel" } },
                        { "n", "zo",             actions.open_fold,                      { desc = "Expand fold" } },
                        { "n", "h",              actions.close_fold,                     { desc = "Collapse fold" } },
                        { "n", "zc",             actions.close_fold,                     { desc = "Collapse fold" } },
                        { "n", "za",             actions.toggle_fold,                    { desc = "Toggle fold" } },
                        { "n", "zR",             actions.open_all_folds,                 { desc = "Expand all folds" } },
                        { "n", "zM",             actions.close_all_folds,                { desc = "Collapse all folds" } },
                        { "n", "<c-b>",          actions.scroll_view(-0.25),             { desc = "Scroll the view up" } },
                        { "n", "<c-f>",          actions.scroll_view(0.25),              { desc = "Scroll the view down" } },
                        { "n", "J",              actions.select_next_entry,              { desc = "Open the diff for the next file" } },
                        { "n", "K",              actions.select_prev_entry,              { desc = "Open the diff for the previous file" } },
                        { "n", "gf",             actions.goto_file_edit,                 { desc = "Open the file in the previous tabpage" } },
                        { "n", "<C-w><C-f>",     actions.goto_file_split,                { desc = "Open the file in a new split" } },
                        { "n", "<C-w>gf",        actions.goto_file_tab,                  { desc = "Open the file in a new tabpage" } },
                        { "n", "i",              actions.listing_style,                  { desc = "Toggle between 'list' and 'tree' views" } },
                        { "n", "f",              actions.toggle_flatten_dirs,            { desc = "Flatten empty subdirectories in tree listing style" } },
                        { "n", "R",              actions.refresh_files,                  { desc = "Update stats and entries in the file list" } },
                        { "n", "<leader>e",      actions.focus_files,                    { desc = "Bring focus to the file panel" } },
                        { "n", "<leader>b",      actions.toggle_files,                   { desc = "Toggle the file panel" } },
                        { "n", "g<C-x>",         actions.cycle_layout,                   { desc = "Cycle available layouts" } },
                        { "n", "[x",             actions.prev_conflict,                  { desc = "Go to the previous conflict" } },
                        { "n", "]x",             actions.next_conflict,                  { desc = "Go to the next conflict" } },
                        { "n", "g?",             actions.help("file_panel"),             { desc = "Open the help panel" } },
                        { "n", "<leader>cO",     actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
                        { "n", "<leader>cT",     actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
                        { "n", "<leader>cB",     actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
                        { "n", "<leader>cA",     actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
                        { "n", "dX",             actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
                    },
                    file_history_panel = {
                        { "n", "g!",            actions.options,                     { desc = "Open the option panel" } },
                        { "n", "<C-A-d>",       actions.open_in_diffview,            { desc = "Open the entry under the cursor in a diffview" } },
                        { "n", "y",             actions.copy_hash,                   { desc = "Copy the commit hash of the entry under the cursor" } },
                        { "n", "L",             actions.open_commit_log,             { desc = "Show commit details" } },
                        { "n", "zR",            actions.open_all_folds,              { desc = "Expand all folds" } },
                        { "n", "zM",            actions.close_all_folds,             { desc = "Collapse all folds" } },
                        { "n", "j",             actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
                        { "n", "<down>",        actions.next_entry,                  { desc = "Bring the cursor to the next file entry" } },
                        { "n", "k",             actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
                        { "n", "<up>",          actions.prev_entry,                  { desc = "Bring the cursor to the previous file entry." } },
                        { "n", "<cr>",          actions.select_entry,                { desc = "Open the diff for the selected entry." } },
                        { "n", "o",             actions.select_entry,                { desc = "Open the diff for the selected entry." } },
                        { "n", "<2-LeftMouse>", actions.select_entry,                { desc = "Open the diff for the selected entry." } },
                        { "n", "<c-b>",         actions.scroll_view(-0.25),          { desc = "Scroll the view up" } },
                        { "n", "<c-f>",         actions.scroll_view(0.25),           { desc = "Scroll the view down" } },
                        { "n", "J",             actions.select_next_entry,           { desc = "Open the diff for the next file" } },
                        { "n", "K",             actions.select_prev_entry,           { desc = "Open the diff for the previous file" } },
                        { "n", "gf",            actions.goto_file_edit,              { desc = "Open the file in the previous tabpage" } },
                        { "n", "<C-w><C-f>",    actions.goto_file_split,             { desc = "Open the file in a new split" } },
                        { "n", "<C-w>gf",       actions.goto_file_tab,               { desc = "Open the file in a new tabpage" } },
                        { "n", "<leader>e",     actions.focus_files,                 { desc = "Bring focus to the file panel" } },
                        { "n", "<leader>b",     actions.toggle_files,                { desc = "Toggle the file panel" } },
                        { "n", "g<C-x>",        actions.cycle_layout,                { desc = "Cycle available layouts" } },
                        { "n", "g?",            actions.help("file_history_panel"),  { desc = "Open the help panel" } },
                    },
                    option_panel = {
                        { "n", "J",     actions.select_entry,          { desc = "Change the current option" } },
                        { "n", "q",     actions.close,                 { desc = "Close the panel" } },
                        { "n", "g?",    actions.help("option_panel"),  { desc = "Open the help panel" } },
                    },
                    help_panel = {
                        { "n", "q",     actions.close,  { desc = "Close help menu" } },
                        { "n", "<esc>", actions.close,  { desc = "Close help menu" } },
                    },
                },
            })

            vim.keymap.set('n', '<leader>dv', '<cmd>DiffviewOpen<CR>', {
                desc = "Open the diffview"
            })
        end
    },
    {
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
    },
    'vim-test/vim-test',
    'michaeljsmith/vim-indent-object',
    'romainl/vim-cool',
    {
        'christoomey/vim-tmux-navigator',
        lazy = false,
    },
    'szw/vim-maximizer',
    'djoshea/vim-autoread',
    {
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
            vim.keymap.set('n', 'K', function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end)

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
                        local ranges = await(require("ufo").getFolds(bufnr, "indent"))
                        local ok = require("ufo").applyFolds(bufnr, ranges)
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
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function ()
            require('neogen').setup {
                enabled = true,             --if you want to disable Neogen
                input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
                -- jump_map = "<C-e>"       -- (DROPPED SUPPORT, see [here](#cycle-between-annotations) !) The keymap in order to jump in the annotation fields (in insert mode)
            }

            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<leader>ds", ":lua require('neogen').generate()<CR>", opts)
        end
    },
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && yarn install",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
}
