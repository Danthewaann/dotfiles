local utils = require("custom.utils")

local ft_map = {
  go = {
    breakpoint_stmt = "runtime.Breakpoint()",
    get_all_cmd = ":silent grep runtime.Breakpoint\\(\\) -g \"*.go\" ./ ",
    post_set_hook = function()
      local cursor_line = vim.fn.line(".")
      -- Check if the `runtime` package has been imported or not
      -- Need to move the cursor to the start of the current buffer to do the search
      -- After the search is done, we jump back to the line where we added the breakpoint
      vim.fn.cursor(1, 0)
      -- Check if "runtime" is found. If it is found we don't run the code action to import it
      if vim.fn.search("\"runtime\"", "n") == 0 then
        vim.fn.cursor(cursor_line, 0)
        -- Automatically import go `runtime` package via a code action
        vim.lsp.buf.code_action({
          apply = true,
          filter = function(x) return x.kind == "source.organizeImports" end
        })
      else
        vim.fn.cursor(cursor_line, 0)
      end
    end
  },
  python = {
    breakpoint_stmt = "breakpoint()",
    get_all_cmd = ":silent grep breakpoint\\(\\) -g \"*.py\" ./",
  },
  ruby = {
    breakpoint_stmt = "binding.pry",
    get_all_cmd = ":silent grep binding.pry -g \"*.rb\" ./",
  }
}

local function set_breakpoint()
  local file_type = vim.fn.getbufvar(vim.api.nvim_get_current_buf(), "&filetype")
  local breakpoint_data = ft_map[file_type]
  if breakpoint_data == nil then
    utils.print_err("File not supported for breakpoints!")
    return
  end

  local breakpoint_stmt = breakpoint_data.breakpoint_stmt
  local post_set_hook = breakpoint_data.post_set_hook

  -- Move the cursor down and to the start of the line for the newly inserted breakpoint
  vim.cmd("norm! o" .. breakpoint_stmt)

  if post_set_hook ~= nil then
    post_set_hook()
  end
end

local function get_all_breakpoints()
  local file_type = vim.fn.getbufvar(vim.api.nvim_get_current_buf(), "&filetype")
  local breakpoint_data = ft_map[file_type]
  if breakpoint_data == nil then
    utils.print_err("File not supported for breakpoints!")
    return false
  end

  vim.cmd(breakpoint_data.get_all_cmd)
  return true
end

vim.keymap.set("n", "<leader>bp", set_breakpoint, { desc = "Add [B]reak[p]oint" })
vim.keymap.set("n", "<leader>bd", function()
  if get_all_breakpoints() then
    local num = vim.fn.getqflist()
    if #num > 0 then
      utils.print("Deleting all breakpoints...")
      vim.cmd(":silent cfdo g/\"runtime\"/d")
      vim.cmd(":silent cdo delete")
      -- Refresh the breakpoints location list
      get_all_breakpoints()
    else
      utils.print_err("No breakpoints found!")
    end
  end
end, { desc = "[B]reakpoints [D]elete" })
vim.keymap.set("n", "<leader>bs", function()
  if get_all_breakpoints() then
    local num = vim.fn.getqflist()
    if #num > 0 then
      vim.cmd(":copen")
    else
      utils.print_err("No breakpoints found!")
    end
  end
end, { desc = "[B]reakpoints [S]how" })
