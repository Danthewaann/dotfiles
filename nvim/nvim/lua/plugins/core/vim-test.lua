local setup_runners = false
local utils = require("custom.utils")

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

local function setup_test_runners()
  if setup_runners then
    return
  end

  local custom_runners = {}
  local enabled_runners = {}

  for runner, data in pairs(test_runners) do
    custom_runners[runner] = { data.custom }
    vim.g["test#" .. runner .. "#runner"] = data.fallback
    table.insert(enabled_runners, runner .. "#" .. data.fallback)
    table.insert(enabled_runners, runner .. "#" .. data.custom)

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
  dependencies = {
    {
      "tpope/vim-projectionist",
      lazy = false,
      config = function()
        -- Make it easier to jump to the alternate file
        utils.cabbrev("aa", "A")
        utils.cabbrev("as", "AS")
        utils.cabbrev("av", "AV")
        utils.cabbrev("at", "AT")
      end
    },
  },
  init = function()
    -- This must be put here so vim-test picks it up as it loads
    vim.g["test#runner_commands"] = { "PyTest" }
  end,
  config = function()
    vim.g["test#strategy"] = "neovim_sticky"
    vim.g["test#python#pytest#options"] = utils.generate_pytest_options("vim-test")

    -- Theses are only used for the neovim_sticky test strategy
    vim.g["test#neovim#term_position"] = "botright 15"
    vim.g["test#neovim_sticky#kill_previous"] = 0
    vim.g["test#neovim_sticky#reopen_window"] = 1
    -- This means only re-use the term opened by vim-test, not any other terminal
    vim.g["test#neovim_sticky#use_existing"] = 0
    vim.g["test#echo_command"] = 0
    vim.g["test#preserve_screen"] = 1
  end,
  keys = {
    {
      "<leader>tn",
      function()
        setup_test_runners()
        vim.cmd(":TestNearest")
      end,
      desc = "[T]est [N]earest"
    },
    {
      "<leader>tf",
      function()
        setup_test_runners()
        vim.cmd(":TestFile")
      end,
      desc = "[T]est [F]ile"
    },
    {
      "<leader>ts",
      function()
        setup_test_runners()
        vim.cmd(":TestSuite")
      end,
      desc = "[T]est [S]uite"
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
    {
      "<leader>tx",
      function()
        utils.load_pytest_failures()
      end,
      desc = "[T]est view errors [x]"
    },
    {
      "<leader>tq",
      function()
        local qflist = vim.fn.getqflist()
        if #qflist == 0 then
          utils.print("No test failures found to re-run")
          return
        end

        local tests = {}
        for _, test in ipairs(qflist) do
          table.insert(tests, test.module)
        end

        local options = utils.generate_pytest_options("vim-test", false)
        vim.cmd(":PyTest " .. options.nearest .. " " .. table.concat(tests, " "))
      end,
      desc = "[T]est run in [Q]uickfix"
    },
    {
      "<leader>ur",
      function()
        setup_test_runners()
        local msg = {}
        for runner, data in pairs(test_runners) do
          local current = vim.g["test#" .. runner .. "#runner"]
          if current ~= data.custom then
            table.insert(msg, ("- %s: %s"):format(runner, data.custom))
            vim.g["test#" .. runner .. "#runner"] = data.custom
          else
            table.insert(msg, ("- %s: %s"):format(runner, data.fallback))
            vim.g["test#" .. runner .. "#runner"] = data.fallback
          end
        end
        utils.print("Toggling test runners\n\n" .. table.concat(msg, "\n"))
      end,
      desc = "Toggle Test Runners"
    },
  },
}
