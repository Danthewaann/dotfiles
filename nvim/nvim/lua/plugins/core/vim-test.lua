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
    vim.g["test#strategy"] = "neovim_sticky"
    vim.g["test#python#pytest#options"] = { nearest = "-vv" }

    -- Theses are only used for the neovim_sticky test strategy
    vim.g["test#neovim#term_position"] = "botright 20"
    vim.g["test#neovim_sticky#kill_previous"] = 0
    vim.g["test#neovim_sticky#reopen_window"] = 1
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
  },
}
