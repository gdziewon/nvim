-- In construction

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    -- DAP UI for a nice debugger interface
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',

    -- Debugger installations via Mason
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = function(_, keys)
    local dap = require 'dap'
    local dapui = require 'dapui'
    return {
      -- Keybindings for debugging
      { '<F5>', dap.continue, desc = 'Debug: Start/Continue' },
      { '<F1>', dap.step_into, desc = 'Debug: Step Into' },
      { '<F2>', dap.step_over, desc = 'Debug: Step Over' },
      { '<F3>', dap.step_out, desc = 'Debug: Step Out' },
      { '<leader>b', dap.toggle_breakpoint, desc = 'Debug: Toggle Breakpoint' },
      {
        '<leader>B',
        function()
          dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Conditional Breakpoint',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: Open/Close Debug UI' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- Mason DAP setup for C/C++ and Rust debuggers
    require('mason-nvim-dap').setup {
      ensure_installed = {
        'cpptools', -- C/C++ Debugger
        'codelldb', -- Rust Debugger
      },
      automatic_installation = true,
      handlers = {},
    }

    -- Setup DAP UI
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Open DAP UI automatically on session start and close on session end
    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- C/C++ configuration using cpptools
    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = vim.fn.stdpath 'data' .. '/mason/bin/OpenDebugAD7', -- Mason installs cpptools
    }

    dap.configurations.cpp = {
      {
        name = 'Launch C/C++',
        type = 'cppdbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
        setupCommands = {
          {
            text = '-enable-pretty-printing',
            description = 'Enable pretty printing',
            ignoreFailures = false,
          },
        },
      },
    }

    -- Apply the same configuration for C
    dap.configurations.c = dap.configurations.cpp

    -- Rust configuration using codelldb
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = vim.fn.stdpath 'data' .. '/mason/bin/codelldb', -- Mason installs codelldb
        args = { '--port', '${port}' },
      },
    }

    dap.configurations.rust = {
      {
        name = 'Launch Rust',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }
  end,
}
