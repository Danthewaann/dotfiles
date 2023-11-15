return {
  "stevearc/qf_helper.nvim",
  config = function()
    require("qf_helper").setup({
      quickfix = {
        autoclose = true,          -- Autoclose qf if it's the only open window
        default_bindings = false,   -- Set up recommended bindings in qf window
        default_options = true,    -- Set recommended buffer and window options
        max_height = 20,           -- Max qf height when using open() or toggle()
        min_height = 5,            -- Min qf height when using open() or toggle()
        track_location = true,     -- Keep qf updated with your current location
      },
      loclist = {                  -- The same options, but for the loclist
        autoclose = true,
        default_bindings = false,
        default_options = true,
        max_height = 20,
        min_height = 5,
        track_location = true,
      },
    })

    vim.keymap.set("n", "]q", "<CMD>QNext<CR>", {desc = "Jump to [count] next entry qf/location list"})
    vim.keymap.set("n", "[q", "<CMD>QPrev<CR>")
    -- toggle the quickfix open/closed without jumping to it
    vim.keymap.set("n", "<leader>q", "<CMD>QFToggle!<CR>", {desc = "Toggle [Q]uickfix list window"})
    vim.keymap.set("n", "<leader>l", "<CMD>LLToggle!<CR>", {desc = "Toggle [L]ocation list window"})
  end
}
