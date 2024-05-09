return {
  "vim-test/vim-test",
  event = "VeryLazy",
  config = function()
    local utils = require("custom.utils")

    vim.g["test#strategy"] = "tslime"
    vim.g["test#echo_command"] = 0
    vim.g["test#preserve_screen"] = 1

    local test_runners = {
      python = {
        custom = "make",
        fallback = "pytest",
        pattern = "test_*.py"
      },
      go = {
        custom = "make",
        fallback = "gotest",
        pattern = "*_test.go"
      },
      ruby = {
        custom = "make",
        fallback = "rspec",
        pattern = "*_spec.rb"
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

      -- From https://github.com/vim-test/vim-test/issues/147#issuecomment-667483332
      -- Try to infer the test suite, so that :TestSuite works without opening a test file
      if vim.fn.exists("g:test#last_position") == 1 then
        goto continue
      end

      local path = vim.fn.trim(
        vim.fn.system(
          "find ./ -iname " ..
          vim.fn.shellescape(data.pattern) ..
          " -print -quit 2> /dev/null"
        )
      )
      if path and path ~= "" then
        -- Set the last test position
        vim.g["test#last_position"] = { file = path, col = 1, line = 1 }
      end

      ::continue::
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
        utils.print_err("Not a test file")
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
        utils.print("Starting test docker container...")
        local container = vim.fn.trim(vim.fn.system("get-test-container --start"))
        if vim.v.shell_error ~= 0 then
          utils.print_err("Failed to start test container!\n" .. container)
          return
        end

        local remote_path = vim.fn.trim(vim.fn.system("get-remote-path"))
        if vim.v.shell_error ~= 0 then
          utils.print_err("Failed to get remote path!\n" .. remote_path)
          return
        end

        print(remote_path)
        debug_config.configuration = language .. " - remote test launch"
        debug_config.remotePath = remote_path
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
