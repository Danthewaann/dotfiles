return {
  "chrishrb/gx.nvim",
  keys = { "gx" },
  config = function()
    local function file_exists(name)
      local f = io.open(name, "r")
      return f ~= nil and io.close(f)
    end

    local browser_app = ""
    local browser_args = {}

    if file_exists("/proc/sys/fs/binfmt_misc/WSLInterop") then
      browser_app = "powershell.exe"
      browser_args = { "start explorer.exe" }
    elseif jit.os == "OSX" then
      browser_app = "open"
      browser_args = { "--background" }
    else
      browser_app = "xdg-open"
      browser_args = {}
    end

    require("gx").setup({
      open_browser_app = browser_app,   -- specify your browser app; default for macOS is "open", Linux "xdg-open" and Windows "powershell.exe"
      open_browser_args = browser_args, -- specify any arguments, such as --background for macOS' "open".
      handlers = {
        plugin = true,                  -- open plugin links in lua (e.g. packer, lazy, ..)
        github = true,                  -- open github issues
        brewfile = true,                -- open Homebrew formulaes and casks
        package_json = true,            -- open dependencies from package.json
        search = true,                  -- search the web/selection on the web if nothing else is found
      },
      handler_options = {
        search_engine = "google", -- you can select between google, bing and duckduckgo
      },
    })

    vim.g.netrw_nogx = 1 -- disable netrw gx
    vim.keymap.set({ "n", "x" }, "gx", require("gx").open)
  end,
}
