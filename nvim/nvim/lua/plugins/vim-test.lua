local utils = require("custom.utils")

local prefer_makefile = true
local use_neotest = true
local use_neovim_term = false
local has_makefile = vim.fn.executable("make") and vim.fn.empty(vim.fn.glob("Makefile")) == 0

local setup_runners = false

local function setup_test_runners()
  if setup_runners then
    return
  end

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
  setup_runners = true
end

return {
  "vim-test/vim-test",
  lazy = false,
  config = function()
    if use_neovim_term then
      vim.g["test#strategy"] = "neovim_sticky"
    else
      vim.g["test#strategy"] = "tslime"
    end
    vim.g["test#neovim#term_position"] = "botright 15"
    vim.g["test#neovim_sticky#kill_previous"] = 1
    vim.g["test#neovim_sticky#reopen_window"] = 1
    vim.g["test#echo_command"] = 0
    vim.g["test#preserve_screen"] = 1
  end,
  keys = {
    {
      "<leader>tT",
      function()
        if use_neovim_term then
          vim.g["test#strategy"] = "tslime"
          utils.print("Toggling tmux terminal")
        else
          vim.g["test#strategy"] = "neovim_sticky"
          utils.print("Toggling nvim terminal")
        end

        use_neovim_term = not use_neovim_term
      end,
      desc = "[T]est [T]oggle Strategy"
    },
    {
      "<leader>td",
      function()
        setup_test_runners()

        local position = utils.get_cursor_position(vim.fn.expand("%"))
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

          debug_config.configuration = language .. " - remote test launch"
          debug_config.remotePath = remote_path
        else
          debug_config.configuration = language .. " - debug test"
        end

        -- Set the last test position
        vim.g["test#last_position"] = position

        vim.fn["vimspector#LaunchWithSettings"](debug_config)
      end,
      desc = "[T]est [D]ebug nearest"
    },
    {
      "<leader>tn",
      function()
        setup_test_runners()

        if not use_neotest or (prefer_makefile and has_makefile) then
          vim.cmd(":TestNearest")
        else
          vim.system({ "make", "test.local.setup" }):wait()
          require("neotest").run.run()
        end
      end,
      desc = "[T]est [N]earest"
    },
    {
      "<leader>tf",
      function()
        setup_test_runners()

        if not use_neotest or (prefer_makefile and has_makefile) then
          vim.cmd(":TestFile")
        else
          require("neotest").run.run(vim.fn.expand("%"))
        end
      end,
      desc = "[T]est [F]ile"
    },
    {
      "<leader>ts",
      function()
        setup_test_runners()

        if not use_neotest or (prefer_makefile and has_makefile) then
          vim.cmd(":TestSuite")
        else
          require("neotest").run.run({ suite = true })
          require("neotest").summary.open()
        end
      end,
      desc = "[T]est [S]uite"
    },
    {
      "<leader>ta",
      function() require("neotest").run.attach() end,
      desc = "[T]est [A]ttach"
    },
    {
      "<leader>to",
      function() require("neotest").output_panel.toggle() end,
      desc = "[T]est [O]utput"
    },
    {
      "<leader>tr",
      function() require("neotest").summary.open() end,
      desc = "[T]est Summa[R]y"
    },
    {
      "<leader>tc",
      function()
        setup_test_runners()
        vim.cmd(":TestClass")
      end,
      desc = "[T]est [C]lass"
    },
    {
      "<leader>tl",
      function()
        setup_test_runners()
        vim.cmd(":TestLast")
      end,
      desc = "[T]est [L]ast"
    },
    {
      "<leader>tv",
      function()
        setup_test_runners()
        vim.cmd(":TestVisit")
      end,
      desc = "[T]est [V]isit"
    },
  },
  dependencies = { "nvim-neotest/neotest" },
}
