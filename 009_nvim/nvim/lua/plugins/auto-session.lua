return {
  "rmagatti/auto-session",
  config = function()
    local sessions = vim.fn.stdpath("data") .. "/sessions/"
    if not vim.loop.fs_stat(sessions) then
      vim.fn.system("mkdir -p " .. sessions)
    end

    require("auto-session").setup({
      auto_save_enabled = true,
      auto_session_root_dir = sessions,
    })
  end
}
