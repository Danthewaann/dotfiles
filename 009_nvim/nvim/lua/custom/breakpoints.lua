local utils = require("custom.utils")

-- Custom stuff for adding breakpoint() statements
--
-- Partially from https://gist.github.com/berinhard/523420
local function get_line_content_and_whitespace(line_num)
  local line = vim.fn.getline(line_num)
  local whitespace = vim.fn.strlen(vim.fn.matchstr(line, "^\\s*"))
  return { content = line, whitespace = whitespace }
end

local function set_breakpoint()
  local cur_line_num = vim.fn.line(".")
  local cur_line = get_line_content_and_whitespace(cur_line_num)

  local next_line = get_line_content_and_whitespace(cur_line_num + 1)
  if cur_line.whitespace > 0 and next_line.whitespace > cur_line.whitespace then
    cur_line.whitespace = next_line.whitespace
  else
    while cur_line.whitespace == 0 do
      if cur_line_num == 0 then
        break
      end
      cur_line_num = cur_line_num - 1
      cur_line = get_line_content_and_whitespace(cur_line_num)
    end

    next_line = get_line_content_and_whitespace(cur_line_num + 1)
    if cur_line.whitespace > 0 and next_line.whitespace > cur_line.whitespace then
      cur_line.whitespace = next_line.whitespace
    end
  end

  local file_type = vim.fn.getbufvar(vim.api.nvim_get_current_buf(), "&filetype")
  local breakpoint_stmt = nil
  local whitespace_char = nil
  if file_type == "go" then
    breakpoint_stmt = "runtime.Breakpoint()"
    whitespace_char = "	"
  elseif file_type == "python" then
    breakpoint_stmt = "breakpoint()"
    whitespace_char = " "
  else
    utils.print_err("File not supported for breakpoints!")
    return
  end

  local output = ""
  for _ = 1, cur_line.whitespace do
    output = output .. whitespace_char
  end

  output = output .. breakpoint_stmt
  vim.fn.append(vim.fn.line("."), output)
  if file_type == "go" then
    -- Move the cursor down and to the start of the line for the newly inserted breakpoint
    vim.cmd("norm! j_")
    -- Automatically import go `runtime` package via a code action
    vim.lsp.buf.code_action({ apply = true })
  end
end

local function get_all_breakpoints()
  local file_type = vim.fn.getbufvar(vim.api.nvim_get_current_buf(), "&filetype")
  if file_type == "go" then
    vim.cmd(":silent lgrep runtime.Breakpoint\\(\\) -g \"*.go\" ./ ")
  elseif file_type == "python" then
    vim.cmd(":silent lgrep breakpoint\\(\\) -g \"*.py\" ./")
  else
    utils.print_err("File not supported for breakpoints!")
    return false
  end
  return true
end

vim.keymap.set("n", "<leader>bp", set_breakpoint, { desc = "Add [B]reak[p]oint" })
vim.keymap.set("n", "<leader>bd", function()
  if get_all_breakpoints() then
    local num = vim.fn.getloclist(0)
    if #num > 0 then
      utils.print("Deleting all breakpoints...")
      vim.cmd(":silent lfdo g/\"runtime\"/d")
      vim.cmd(":silent ldo delete")
      -- Refresh the breakpoints location list
      get_all_breakpoints()
    else
      utils.print_err("No breakpoints found!")
    end
  end
end, { desc = "[B]reakpoints [D]elete" })
vim.keymap.set("n", "<leader>bs", function()
  if get_all_breakpoints() then
    local num = vim.fn.getloclist(0)
    if #num > 0 then
      vim.cmd(":lopen")
    else
      utils.print_err("No breakpoints found!")
    end
  end
end, { desc = "[B]reakpoints [S]how" })
