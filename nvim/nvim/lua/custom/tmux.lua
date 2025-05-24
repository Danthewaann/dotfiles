M = {}

M.send_to_tmux = function(args)
  local windows = vim.tbl_map(tonumber,
    vim.split(vim.system({ "tmux", "list-windows", "-F", "#{window_index}" }):wait().stdout, "\n")
  )

  local cur_window = vim.system({ "tmux", "display-message", "-p", "#I" }):wait().stdout
  assert(cur_window)

  local next_window = tonumber(cur_window) + 1

  local found = false
  for _, win in ipairs(windows) do
    if next_window == win then
      vim.system({ "tmux", "select-window", "-t", tostring(next_window) }):wait()
      found = true
      break
    end
  end

  if not found then
    vim.system({ "tmux", "new-window", "-a", "-c", "#{pane_current_path}" }):wait()
  end

  local window_id = ":" .. tostring(next_window) .. ".0"

  if found then
    vim.system({ "tmux", "send-keys", "-t", window_id, "C-c" }):wait()
  end

  vim.system({ "tmux", "send-keys", "-t", window_id, args, "Enter" }):wait()
  vim.system({ "tmux", "select-window", "-t", window_id }):wait()
end

return M
