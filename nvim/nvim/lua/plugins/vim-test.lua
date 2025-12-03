local utils = require("custom.utils")
local tmux = require("custom.tmux")

local test_strategies = { "neotest", "nvim", "tmux" }
local cur_test_strategy = 1
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
  local use_make = false
  local has_makefile = vim.fn.executable("make") and vim.fn.empty(vim.fn.glob("Makefile")) == 0
  local has_dockerfile = vim.fn.empty(vim.fn.glob("Dockerfile")) == 0
  if has_makefile and has_dockerfile then
    local obj = vim.system({ "grep", "^unit:", "Makefile" }):wait()
    if obj.code == 0 then
      use_make = true
      cur_test_strategy = 2
      vim.g["test#strategy"] = "neovim_sticky"
    end
  end

  for runner, data in pairs(test_runners) do
    custom_runners[runner] = { data.custom }
    if use_make then
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
  config = function()
    vim.g["test#neovim#term_position"] = "botright 15"
    vim.g["test#neovim_sticky#kill_previous"] = 1
    vim.g["test#neovim_sticky#reopen_window"] = 1
    vim.g["test#echo_command"] = 0
    vim.g["test#preserve_screen"] = 1
    vim.g["test#custom_strategies"] = { tmux = tmux.send_to_tmux }
  end,
  keys = {
    {
      "<leader>tS",
      function()
        cur_test_strategy = cur_test_strategy + 1
        if cur_test_strategy > #test_strategies then
          cur_test_strategy = 1
        end

        local new_strategy = test_strategies[cur_test_strategy]
        if new_strategy == "nvim" then
          vim.g["test#strategy"] = "neovim_sticky"
          utils.print("Using nvim test strategy")
        elseif new_strategy == "tmux" then
          vim.g["test#strategy"] = "tmux"
          utils.print("Using tmux test strategy")
        else
          utils.print("Using neotest test strategy")
        end
      end,
      desc = "[T]oggle Test [S]trategy"
    },
    {
      "<leader>tn",
      function()
        setup_test_runners()

        local test_strategy = test_strategies[cur_test_strategy]
        if test_strategy == "nvim" or test_strategy == "tmux" then
          vim.cmd(":TestNearest")
        else
          local extra_args = {}
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype == "python" then
            extra_args = { "-vvv" }
          end
          require("neotest").run.run({ extra_args = extra_args })
        end
      end,
      desc = "[T]est [N]earest"
    },
    {
      "<leader>td",
      function()
        setup_test_runners()

        local test_strategy = test_strategies[cur_test_strategy]
        if test_strategy == "neotest" then
          local extra_args = {}
          local buf = vim.api.nvim_get_current_buf()
          if vim.bo[buf].filetype == "python" then
            extra_args = { "-vvv" }
          end
          require("neotest").run.run({ extra_args = extra_args, strategy = "dap" })
        else
          utils.print_err("Debugging not supported with current test strategy: " .. test_strategy)
        end
      end,
      desc = "[T]est [D]ebug Nearest"
    },
    {
      "<leader>tf",
      function()
        setup_test_runners()

        local test_strategy = test_strategies[cur_test_strategy]
        if test_strategy == "nvim" or test_strategy == "tmux" then
          vim.cmd(":TestFile")
        else
          require("neotest").run.run(vim.fn.expand("%"))
          require("neotest").summary.open()
        end
      end,
      desc = "[T]est [F]ile"
    },
    {
      "<leader>ts",
      function()
        setup_test_runners()

        local test_strategy = test_strategies[cur_test_strategy]
        if test_strategy == "nvim" or test_strategy == "tmux" then
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
      function()
        require("neotest").run.attach()
        vim.cmd("startinsert")
      end,
      desc = "[T]est [A]ttach"
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ short = true, enter = true })
        vim.cmd("startinsert")
      end,
      desc = "[T]est short [O]utput "
    },
    {
      "<leader>tO",
      function()
        require("neotest").output.open({ enter = true })
        vim.cmd("startinsert")
      end,
      desc = "[T]est long [O]utput"
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

        local test_strategy = test_strategies[cur_test_strategy]
        if test_strategy == "nvim" or test_strategy == "tmux" then
          vim.cmd(":TestClass")
        else
          utils.print_err("Test class not supported with current test strategy: " .. test_strategy)
        end
      end,
      desc = "[T]est [C]lass"
    },
    {
      "<leader>tl",
      function()
        setup_test_runners()

        local test_strategy = test_strategies[cur_test_strategy]
        if test_strategy == "nvim" or test_strategy == "tmux" then
          vim.cmd(":TestLast")
        else
          require("neotest").run.run_last()
        end
      end,
      desc = "[T]est [L]ast"
    },
    {
      "<leader>tv",
      function()
        setup_test_runners()

        local test_strategy = test_strategies[cur_test_strategy]
        if test_strategy == "nvim" or test_strategy == "tmux" then
          vim.cmd(":TestVisit")
        else
          local test, _ = require("neotest").run.get_last_run()
          assert(test)

          local t = {}
          for str in string.gmatch(test, "([^:]*)") do
            t[#t + 1] = str
          end

          if #t == 2 then
            vim.cmd(":e " .. t[1])
          else
            if t[3] ~= "" then
              vim.cmd(":e +" .. t[3] .. " " .. t[1])
            elseif t[4] ~= "" then
              -- Split on `[` character as pytest data driven tests contain the sub test name that can't be searched
              local s = {}
              for str in string.gmatch(t[4], "([^\\[]*)") do
                s[#s + 1] = str
              end
              vim.cmd(":e +/" .. s[1] .. " " .. t[1])
            end
          end
        end
      end,
      desc = "[T]est [V]isit"
    },
  },
  dependencies = { "nvim-neotest/neotest" },
}
