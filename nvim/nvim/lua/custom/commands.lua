local utils = require("custom.utils")

vim.api.nvim_create_user_command("Mypy", function()
  utils.print("Running mypy...")
  vim.system(
    utils.mypy_args(true), {}, function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end
        utils.print("Finished running mypy")
        utils.parse_mypy_output(obj.stdout)
      end)
    end)
end, { desc = "Run Mypy and populate quickfix list with errors" })

vim.api.nvim_create_user_command("DMypy", function()
  utils.print("Running dmypy...")
  vim.system(
    utils.dmypy_args(true), {}, function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end
        utils.print("Finished running dmypy")
        utils.parse_mypy_output(obj.stdout)
      end)
    end)
end, { desc = "Run DMypy and populate quickfix list with errors" })

vim.api.nvim_create_user_command("Ruff", function()
  utils.print("Running ruff...")
  vim.system(
    {
      utils.get_venv_executable_path("ruff"),
      "check",
      "--force-exclude",
      "--quiet",
      "--no-fix",
      "--output-format",
      "json",
      ".",
    }, {},
    function(obj)
      vim.schedule(function()
        if obj.code > 1 then
          utils.print_err(vim.fn.trim(obj.stderr))
          return
        end
        utils.print("Finished running ruff")
        utils.parse_ruff_output(obj.stdout)
      end)
    end)
end, { desc = "Run Ruff and populate quickfix list with errors" })

vim.api.nvim_create_user_command("CreateJournalEntry", function()
  local template
  local workspace = os.getenv("TMUX_CURRENT_DIR") .. "/Danthewaann"
  if workspace ~= nil and utils.file_exists(workspace) then
    template = workspace .. "/notes/journal/template.md"
  end

  vim.ui.input({ prompt = "Enter year: ", default = os.date("%Y") }, function(input)
    if input == nil then
      return
    end

    local year = input
    vim.ui.input({ prompt = "Enter week: ", default = os.date("%W") }, function(input2)
      if input2 == nil then
        return
      end

      local week = input2
      local file_week = tonumber(week)
      if file_week < 10 then
        ---@diagnostic disable-next-line: cast-local-type
        file_week = "0" .. file_week
      end
      local journal_entry = workspace .. "/notes/journal/" .. year .. "/week-" .. file_week .. ".md"
      print(template)
      local obj = vim.system({ "create-journal-entry", template, journal_entry, year, week }, { text = true }):wait()
      if obj.code ~= 0 then
        utils.print_err(vim.fn.trim(obj.stderr))
        return
      end
      vim.cmd(":e " .. journal_entry)
    end)
  end)
end, { desc = "Create a new journal entry in notes tmux session" })
