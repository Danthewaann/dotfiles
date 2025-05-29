return {
  "mfussenegger/nvim-dap",
  dependencies = {
    -- Creates a beautiful debugger UI
    "rcarriga/nvim-dap-ui",

    -- Required dependency for nvim-dap-ui
    "nvim-neotest/nvim-nio",

    -- Add your own debuggers here
    "mfussenegger/nvim-dap-python",
  },
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Debug: Start/Continue",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Debug: Step Over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Debug: Step Into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Debug: Step Out",
    },
    {
      "<leader>bp",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle [B]reak[p]oint",
    },
    {
      "<leader>bc",
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      desc = "Add [B]reakpoint [C]ondition",
    },
    {
      "<leader>bl",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
      end,
      desc = "Add [B]reakpoint [L]og",
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      "<F7>",
      function()
        require("dapui").toggle()
      end,
      desc = "Debug: See last session result.",
    },
    {
      "<leader>de",
      function()
        require("dap").set_exception_breakpoints()
      end,
      desc = "[D]ebug Set [E]xception Breakpoints",
    },
    {
      "<leader>dh",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "[D]ebug [H]over",
    },
    {
      "<leader>dp",
      function()
        require("dap.ui.widgets").preview()
      end,
      desc = "[D]ebug [P]review",
    },
    {
      "<leader>df",
      function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.frames)
      end,
      desc = "[D]ebug [F]rames",
    },
    {
      "<leader>ds",
      function()
        local widgets = require("dap.ui.widgets")
        widgets.centered_float(widgets.scopes)
      end,
      desc = "[D]ebug [S]copes",
    },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
      floating = {
        mappings = {
          expand = { "<Tab>" }
        },
      },
      mappings = {
        expand = { "<Tab>", "<2-LeftMouse>" },
      },
      controls = {
        icons = {
          pause = "⏸",
          play = "▶",
          step_into = "⏎",
          step_over = "⏭",
          step_out = "⏮",
          step_back = "b",
          run_last = "▶▶",
          terminate = "⏹",
          disconnect = "⏏",
        },
      },
    }

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("dap-float-binds", { clear = true }),
      pattern = "dap-float",
      callback = function(args)
        vim.keymap.set("n", "<Tab>", "<cmd>lua require('dap.ui').trigger_actions({ mode = 'first' })<CR>",
          { buffer = args.buf })
      end
    })

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
    vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = "", BreakpointCondition = "", BreakpointRejected = "", LogPoint = "", Stopped = "" }
        or { Breakpoint = "●", BreakpointCondition = "⊜", BreakpointRejected = "⊘", LogPoint = "◆", Stopped = "⭔" }
    for type, icon in pairs(breakpoint_icons) do
      local tp = "Dap" .. type
      local hl = (type == "Stopped") and "DapStop" or "DapBreak"
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    -- Don't pause on exceptions for python tests
    dap.defaults.python.exception_breakpoints = {}

    local utils = require("custom.utils")
    require("dap-python").setup(utils.get_poetry_venv_executable_path("python"))
  end,
}
