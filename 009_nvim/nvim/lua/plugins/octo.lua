return {
  "pwntester/octo.nvim",
  event = "VeryLazy",
  cmd = "Octo",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
    local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
    local utils = require("custom.utils")

    vim.treesitter.language.register("markdown", "octo")

    require("octo").setup({
      suppress_missing_scope = {
        projects_v2 = true,
      },
      mappings = {
        review_thread = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        },
        review_diff = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        },
        file_panel = {
          close_review_tab = { lhs = "" },
          select_next_entry = { lhs = "<C-j>", desc = "move to previous changed file" },
          select_prev_entry = { lhs = "<C-k>", desc = "move to next changed file" },
        }
      }
    })

    augroup("octo", { clear = true })
    autocmd("FileType", {
      group = "octo",
      pattern = "octo_panel",
      callback = function()
        vim.keymap.set(
          "n",
          "<leader>vc",
          "<cmd> Octo review commit<CR>",
          { buffer = true, desc = "review commit" }
        )
      end,
    })

    vim.keymap.set("n", "<leader>gh", function()
      local function get_ticket_url()
        local ticket_number = vim.fn.trim(vim.fn.system("get-ticket-number"))
        if vim.v.shell_error ~= 0 then
          M.print_err(ticket_number)
          return nil
        end

        local base_url = vim.fn.expand("$BASE_TICKETS_URL")
        if base_url == "$BASE_TICKETS_URL" then
          M.print_err("BASE_TICKETS_URL environment variable is not set!")
          return nil
        end

        return base_url .. ticket_number
      end


      local commands = {
        ["1. Open PR"] = function()
          local obj = vim.system({ "gh", "prv" }):wait()
          if obj.code ~= 0 then
            M.print_err(obj.stderr)
            return
          end
        end,
        ["2. Open Repository"] = function()
          local obj = vim.system({ "gh", "rv" }):wait()
          if obj.code ~= 0 then
            M.print_err(obj.stderr)
            return
          end
        end,
        ["3. Open Ticket"] = function()
          local ticket_url = get_ticket_url()
          if ticket_url == nil then
            return
          end

          vim.ui.open(ticket_url)
        end,
        ["4. Yank Ticket"] = function()
          local ticket_url = get_ticket_url()
          if ticket_url == nil then
            return
          end

          local cb_opts = vim.opt.clipboard:get()
          if vim.tbl_contains(cb_opts, "unnamed") then vim.fn.setreg("*", ticket_url) end
          if vim.tbl_contains(cb_opts, "unnamedplus") then
            vim.fn.setreg("+", ticket_url)
          end
          vim.fn.setreg("", ticket_url)
          utils.print("Copied " .. ticket_url .. " to clipboard")
        end,
      }

      local keys = vim.tbl_keys(commands)
      table.sort(keys)

      vim.ui.select(
        keys,
        { prompt = "Github" },
        function(choice)
          for key, value in pairs(commands) do
            if choice == key then
              value()
              return
            end
          end
        end
      )
    end, { desc = "[G]it[H]ub commands" })
  end
}
