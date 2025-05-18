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
  event = "VeryLazy",
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
      "<leader>tn",
      function()
        setup_test_runners()

        if not use_neotest or (prefer_makefile and has_makefile) then
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

        if not use_neotest or (prefer_makefile and has_makefile) then
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

        if not use_neotest or (prefer_makefile and has_makefile) then
          vim.cmd(":TestVisit")
        else
          vim.print(require("neotest").run.get_last_run())
        end
      end,
      desc = "[T]est [V]isit"
    },
  },
  dependencies = { "nvim-neotest/neotest" },
}
