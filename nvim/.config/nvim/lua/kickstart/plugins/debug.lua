-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
        'debugpy',
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
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

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }

    -- Install python specific config
    dap.adapters.python = function(cb, config)
      if config.request == 'attach' then
        ---@diagnostic disable-next-line: undefined-field
        local port = (config.connect or config).port
        ---@diagnostic disable-next-line: undefined-field
        local host = (config.connect or config).host or '127.0.0.1'
        cb {
          type = 'server',
          port = assert(port, '`connect.port` or `port` is required for a python `attach` configuration'),
          host = host,
          options = {
            source_filetype = 'python',
          },
        }
      else
        -- Try to find debugpy-adapter or python with debugpy module
        local cwd = vim.fn.getcwd()
        local debugpy_adapter = cwd .. '/.venv/bin/debugpy-adapter'
        
        if vim.fn.executable(debugpy_adapter) == 1 then
          cb {
            type = 'executable',
            command = debugpy_adapter,
            options = {
              source_filetype = 'python',
            },
          }
        else
          -- Fallback to python -m debugpy.adapter
          local python_path = vim.fn.exepath 'python'
          if python_path == '' then
            python_path = cwd .. '/.venv/bin/python'
            if vim.fn.executable(python_path) == 0 then
              python_path = 'python3'
            end
          end
          cb {
            type = 'executable',
            command = python_path,
            args = { '-m', 'debugpy.adapter' },
            options = {
              source_filetype = 'python',
            },
          }
        end
      end
    end

    -- Python DAP configurations
    local function get_python_path()
      local python_path = vim.fn.exepath 'python'
      if python_path == '' then
        local cwd = vim.fn.getcwd()
        local venv_path = cwd .. '/.venv/bin/python'
        if vim.fn.executable(venv_path) == 1 then
          python_path = venv_path
        else
          python_path = 'python3'
        end
      end
      return python_path
    end
    
    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = get_python_path(),
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch with arguments',
        program = '${file}',
        args = function()
          local args_string = vim.fn.input('Arguments: ')
          return vim.split(args_string, ' +')
        end,
        pythonPath = get_python_path(),
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Pytest (current file)',
        module = 'pytest',
        args = function()
          return { '${file}', '-v', '-s' }
        end,
        pythonPath = get_python_path(),
        justMyCode = false,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Pytest (specific test)',
        module = 'pytest',
        args = function()
          local test_name = vim.fn.input('Test name (e.g., tests/test_models.py::test_patient_normalise): ')
          return { test_name, '-v', '-s' }
        end,
        pythonPath = get_python_path(),
        justMyCode = false,
      },
    }
  end,
}
