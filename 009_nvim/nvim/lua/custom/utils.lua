M = {}

-- From: https://github.com/nvim-telescope/telescope.nvim/issues/1923#issuecomment-1122642431
M.get_visual_selection = function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg("v")
  vim.fn.setreg("v", {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ""
  end
end

return M
