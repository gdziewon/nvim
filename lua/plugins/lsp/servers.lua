local M = {}

-- List of LSP servers with their configurations
M.list = {
  -- C/C++
  clangd = {
    cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--header-insertion=never' },
  },
  -- Python
  pyright = {
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
          typeCheckingMode = 'off',
        },
      },
    },
  },
  -- Rust
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        assist = { importGranularity = 'module', importPrefix = 'by_self' },
        cargo = { loadOutDirsFromCheck = true, allFeatures = true },
        checkOnSave = { command = 'clippy' },
        procMacro = { enable = true },
        diagnostics = {
          enable = true,
          disabled = { 'unresolved-proc-macro' },
          enableExperimental = true,
        },
        inlayHints = {
          lifetimeElisionHints = { enable = 'always', useParameterNames = true },
          bindingModeHints = { enable = true },
          closureReturnTypeHints = { enable = true },
          typeHints = { enable = true },
          parameterHints = { enable = true },
          chainingHints = { enable = true },
          reborrowHints = { enable = 'always' },
        },
      },
    },
  },
  -- Lua
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
        completion = { callSnippet = 'Replace', keywordSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' }, disable = { 'lowercase-global' } },
        workspace = { library = vim.api.nvim_get_runtime_file('', true), checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
    on_attach = function(client, _)
      client.server_capabilities.documentFormattingProvider = false
    end,
  },
  -- Go
  gopls = {
    settings = {
      gopls = {
        analyses = { unusedparams = true, shadow = true },
        staticcheck = true,
        gofumpt = true,
      },
    },
  },
  -- HTML
  html = { filetypes = { 'html', 'htmldjango' } },
  -- CSS
  cssls = {},
  -- JSON
  jsonls = {
    settings = { json = { schemas = require('schemastore').json.schemas(), validate = { enable = true } } },
  },
  -- YAML
  yamlls = {
    settings = { yaml = { schemas = require('schemastore').yaml.schemas(), validate = true, hover = true, completion = true } },
  },
  -- Bash
  bashls = {},
  -- Docker
  dockerls = {},
  -- Markdown
  marksman = {},
}

-- Setup function for LSP servers
function M.setup(capabilities)
  local lspconfig = require 'lspconfig'

  for server_name, config in pairs(M.list) do
    config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
    lspconfig[server_name].setup(config)
  end
end

return M
