return {
  "vim-test/vim-test",
  config = function()
    vim.g["test#strategy"] = "neovim"
    vim.g["test#neovim#term_position"] = "vertical"
    vim.g["test#neovim#start_normal"] = 0
    vim.g["test#custom_runners"] = { python = { "make" }, go = { "make" } }

    if vim.fn.executable("make") and vim.fn.empty(vim.fn.glob("Makefile")) == 0 then
      vim.g["test#python#runner"] = "make"
      vim.g["test#go#runner"] = "make"
    else
      vim.g["test#python#runner"] = "pytest"
      vim.g["test#go#runner"] = "gotest"
    end

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
      local runner = vim.fn.call("test#determine_runner", { position.file })
      if runner == 0 then
        vim.api.nvim_echo({ { "Not a test file", "WarningMsg" } }, true, {})
        return
      end

      local language, runner_type = unpack(vim.fn.split(runner, "#"))
      local build_args = vim.fn.call("test#" .. runner .. "#build_position", { "nearest", position })
      local args = {}

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

      vim.fn.call("vimspector#LaunchWithSettings", { debug_config })
    end

    vim.keymap.set("n", "<leader>dn", debug_nearest_test, { desc = "[D]ebug [N]earest test" })
    vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<CR>", { desc = "[T]est [N]earest" })
    vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<CR>", { desc = "[T]est [F]ile" })
    vim.keymap.set("n", "<leader>ts", "<cmd>TestSuite<CR>", { desc = "[T]est [S]uite" })
    vim.keymap.set("n", "<leader>tc", "<cmd>TestClass<CR>", { desc = "[T]est [C]lass" })
    vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<CR>", { desc = "[T]est [L]ast" })
    vim.keymap.set("n", "<leader>tv", "<cmd>TestVisit<CR>zz", { desc = "[T]est [V]isit" })
  end
}
