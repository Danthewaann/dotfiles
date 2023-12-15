return {
  "vim-test/vim-test",
  config = function()
    -- Custom toggleterm strategy to display test command output
    -- in either a horizontal or vertical window depending on the
    -- width of the current window
    local function custom_toggleterm_strategy(cmd)
      local width = vim.api.nvim_win_get_width(0)
      if width < 150 then
        require("toggleterm").exec("clear", nil, nil, nil, "horizontal")
        require("toggleterm").exec(cmd, nil, nil, nil, "horizontal")
      else
        require("toggleterm").exec("clear", nil, nil, nil, "vertical")
        require("toggleterm").exec(cmd, nil, nil, nil, "vertical")
      end
    end

    vim.g["test#custom_strategies"] = { custom_toggleterm = custom_toggleterm_strategy }
    vim.g["test#strategy"] = "custom_toggleterm"

    vim.g["test#neovim#term_position"] = "vertical"
    vim.g["test#neovim#start_normal"] = 0

    local test_runners = {
      python = {
        custom = "make",
        fallback = "pytest",
      },
      go = {
        custom = "make",
        fallback = "gotest",
      },
      ruby = {
        custom = "make",
        fallback = "rspec",
      },
    }
    local custom_runners = {}
    local enabled_runners = {}
    local has_makefile = vim.fn.executable("make") and vim.fn.empty(vim.fn.glob("Makefile")) == 0

    for runner, data in pairs(test_runners) do
      custom_runners[runner] = { data.custom }
      if has_makefile then
        vim.g["test#" .. runner .. "#runner"] = data.custom
        table.insert(enabled_runners, runner .. "#" .. data.custom)
      else
        vim.g["test#" .. runner .. "#runner"] = data.fallback
        table.insert(enabled_runners, runner .. "#" .. data.fallback)
      end
    end

    vim.g["test#custom_runners"] = custom_runners
    vim.g["test#enabled_runners"] = enabled_runners

    local function get_cursor_position(path)
      local filename_modifier = vim.g["test#filename_modifier"] or ":."
      local position = {
        file = vim.fn.fnamemodify(path, filename_modifier),
        line = path == vim.fn.expand("%") and vim.fn.line(".") or 1,
        col = path == vim.fn.expand("%") and vim.fn.col(".") or 1,
      }
      return position
    end

    local function debug_nearest_test()
      local position = get_cursor_position(vim.fn.expand("%"))
      local runner = vim.fn["test#determine_runner"](position.file)
      if runner == 0 or runner == nil then
        vim.api.nvim_echo({ { "Not a test file", "WarningMsg" } }, true, {})
        return
      end

      local language, runner_type = unpack(vim.fn.split(runner, "#"))
      local build_args = vim.fn["test#" .. runner .. "#build_position"]("nearest", position)
      assert(build_args)

      local args
      if language == "go" then
        -- Need to reverse the build args for `delve test`
        -- e.g. `-run 'TestCheckWebsites$' .pkg/concurrency` to
        -- `.pkg/concurrency -- -test.run 'TestCheckWebsites$'`
        args = build_args[2] .. " -- " .. "-test.run " .. vim.fn.split(build_args[1])[2]
      else
        args = vim.fn.join(build_args)
      end

      local debug_config = { configuration = "", args = args }

      if runner_type == "make" then
        print("Starting test docker container...")
        local container = vim.fn.trim(vim.fn.system("get-test-container --start"))
        if vim.v.shell_error ~= 0 then
          vim.api.nvim_echo({ { "Failed to start test container!\n" .. container, "ErrorMsg" } }, true, {})
          return
        end
        debug_config.configuration = language .. " - remote test launch"
      else
        debug_config.configuration = language .. " - debug test"
      end

      -- Set the last test position
      vim.g["test#last_position"] = position

      vim.fn["vimspector#LaunchWithSettings"](debug_config)
    end

    vim.keymap.set("n", "<leader>td", debug_nearest_test, { desc = "[T]est [D]ebug nearest" })
    vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<CR>", { desc = "[T]est [N]earest" })
    vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<CR>", { desc = "[T]est [F]ile" })
    vim.keymap.set("n", "<leader>ts", "<cmd>TestSuite<CR>", { desc = "[T]est [S]uite" })
    vim.keymap.set("n", "<leader>tc", "<cmd>TestClass<CR>", { desc = "[T]est [C]lass" })
    vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<CR>", { desc = "[T]est [L]ast" })
    vim.keymap.set("n", "<leader>tv", "<cmd>TestVisit<CR>zz", { desc = "[T]est [V]isit" })
  end
}
