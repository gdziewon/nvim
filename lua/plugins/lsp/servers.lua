local M = {}

-- List of LSP servers with their configurations
M.list = {
  -- **C/C++ Language Server**
  clangd = {
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--header-insertion=never' },
    -- Additional settings can be added here
    -- For example, you can specify the root directory or custom on_attach function
  },

  -- **Python Language Server**
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace', -- Options: 'openFilesOnly', 'workspace'
          typeCheckingMode = 'strict', -- Options: 'off', 'basic', 'strict'
        },
      },
    },
  },

  -- **Rust Analyzer**
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        assist = {
          importGranularity = 'module',
          importPrefix = 'by_self',
        },
        cargo = {
          loadOutDirsFromCheck = true,
          allFeatures = true,
        },
        checkOnSave = {
          command = 'clippy',
        },
        procMacro = {
          enable = true,
        },
        diagnostics = {
          enable = true,
          disabled = { 'unresolved-proc-macro' },
          enableExperimental = true,
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = 'always', -- Options: 'off', 'never', 'always'
            useParameterNames = true,
          },
          bindingModeHints = {
            enable = true,
          },
          closureReturnTypeHints = {
            enable = true,
          },
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
          parameterHints = {
            enable = true,
          },
          chainingHints = {
            enable = true,
          },
          reborrowHints = {
            enable = 'always', -- Options: 'off', 'never', 'always'
          },
        },
      },
    },
  },

  -- **Lua Language Server**
  lua_ls = {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = 'LuaJIT',
          path = vim.split(package.path, ';'),
        },
        completion = {
          callSnippet = 'Replace',
          keywordSnippet = 'Replace',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
          disable = { 'lowercase-global' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file('', true),
          checkThirdParty = false, -- Prevent prompt for third-party library
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  -- **Go Language Server**
  gopls = {
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },

  -- **HTML Language Server**
  html = {
    filetypes = { 'html', 'htmldjango' },
  },

  -- **CSS Language Server**
  cssls = {},

  -- **JSON Language Server**
  jsonls = {
    settings = {
      json = {
        schemas = require('schemastore').json.schemas(),
        validate = { enable = true },
      },
    },
  },

  -- **YAML Language Server**
  yamlls = {
    settings = {
      yaml = {
        schemas = require('schemastore').yaml.schemas(),
        validate = true,
        hover = true,
        completion = true,
      },
    },
  },

  -- **Bash Language Server**
  bashls = {},

  -- **Dockerfile Language Server**
  dockerls = {},

  -- **Markdown Language Server**
  marksman = {},
}

function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  -- Customize the 'on_attach' function for specific servers if needed
  -- Example: Disable formatting for tsserver and use null-ls instead
  if M.list.tsserver then
    M.list.tsserver.on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      -- Additional customizations can be added here
    end
  end

  -- Customize 'on_attach' for Lua LS
  if M.list.lua_ls then
    M.list.lua_ls.on_attach = function(client, bufnr)
      -- Disable formatting if using an external formatter
      client.server_capabilities.documentFormattingProvider = false
    end
  end

  -- Setup JSON Language Server with schemastore
  if M.list.jsonls then
    local jsonls_opts = M.list.jsonls
    local schemastore = require 'schemastore'
    jsonls_opts.settings.json.schemas = schemastore.json.schemas()
    jsonls_opts.capabilities = capabilities
    lspconfig.jsonls.setup(jsonls_opts)
    M.list.jsonls = nil -- Remove from the list to avoid duplicate setup
  end

  -- Setup YAML Language Server with schemastore
  if M.list.yamlls then
    local yamlls_opts = M.list.yamlls
    local schemastore = require 'schemastore'
    yamlls_opts.settings.yaml.schemas = schemastore.yaml.schemas()
    yamlls_opts.capabilities = capabilities
    lspconfig.yamlls.setup(yamlls_opts)
    M.list.yamlls = nil -- Remove from the list to avoid duplicate setup
  end

  -- Additional setup for other servers can be added here
end

return M
