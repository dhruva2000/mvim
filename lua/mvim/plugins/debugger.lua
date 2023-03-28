local icons = mo.styles.icons

-- stop: shift + F5; restart: command + shift + F5
local M = {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<F5>",
      function()
        require("dap").continue({})
      end,
      desc = "Continue",
    },
    {
      "<F17>", -- shift + F5
      function()
        require("dap").terminate()
      end,
      desc = "Terminate",
    },
    {
      "<S-F5>", -- command + shift + F5
      function()
        require("dap").restart()
      end,
      desc = "Restart",
    },
    {
      "<F6>",
      function()
        require("dap").pause()
      end,
      desc = "Pause",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Step out",
    },
  },
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      keys = {
        {
          "<leader>du",
          function()
            require("dapui").toggle()
          end,
          desc = "Toggle DAP UI",
        },
      },
      opts = {
        icons = {
          expanded = icons.documents.expanded,
          collapsed = icons.documents.collapsed,
          current_frame = icons.documents.collapsed,
        },
        layouts = {
          {
            elements = {
              "scopes",
              "stacks",
              "watches",
              "breakpoints",
            },
            size = 0.3,
            position = "right",
          },
          {
            elements = { "repl" },
            size = 0.24,
            position = "bottom",
          },
        },
        controls = {
          icons = icons.dap.controls,
        },
        floating = {
          border = mo.styles.border,
        },
      },
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { highlight_new_as_changed = true },
    },
  },
  init = function()
    for name, icon in pairs(icons.dap.signs) do
      name = "Dap" .. name:gsub("^%l", string.upper)
      vim.fn.sign_define(name, { text = icon, texthl = name })
    end
  end,
  config = function()
    -- setup listener
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      local breakpoints = require("dap.breakpoints").get()
      local args = vim.tbl_isempty(breakpoints) and nil or { layout = 2 }
      dapui.open(args)
    end
    dap.listeners.before.event_stopped["dapui_config"] = function(_, body)
      if body.reason == "breakpoint" then
        dapui.open()
      end
    end

    -- load launch.json file
    require("dap.ext.vscode").load_launchjs(
      vim.fn.getcwd() .. "/" .. mo.settings.metadir .. "/launch.json"
    )

    -- setup adapter
    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
      options = {
        source_filetype = "python",
      },
    }
  end,
}

return M
