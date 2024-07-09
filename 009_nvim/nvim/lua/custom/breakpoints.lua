local utils = require("custom.utils")

local ft_map = {
  go = {
    breakpoint_stmt = "runtime.Breakpoint()",
    whitespace_char = "	",
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
    whitespace_char = " ",
    get_all_cmd = ":silent grep breakpoint\\(\\) -g \"*.py\" ./",
  },
  ruby = {
    breakpoint_stmt = "binding.pry",
    whitespace_char = " ",
    get_all_cmd = ":silent grep binding.pry -g \"*.rb\" ./",
  }
}

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
  local breakpoint_data = ft_map[file_type]
  if breakpoint_data == nil then
    utils.print_err("File not supported for breakpoints!")
    return
  end

  local breakpoint_stmt = breakpoint_data.breakpoint_stmt
  local whitespace_char = breakpoint_data.whitespace_char
  local post_set_hook = breakpoint_data.post_set_hook

  local output = ""
  for _ = 1, cur_line.whitespace do
    output = output .. whitespace_char
  end

  output = output .. breakpoint_stmt
  vim.fn.append(vim.fn.line("."), output)
  -- Move the cursor down and to the start of the line for the newly inserted breakpoint
  vim.cmd("norm! j_")

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
