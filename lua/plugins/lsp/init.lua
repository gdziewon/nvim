return {
  {
    -- LazyDev configures Lua LSP for your Neovim config, runtime, and plugins
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the vim.uv word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'b0o/SchemaStore.nvim',
    version = false,
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'hrsh7th/cmp-nvim-lsp',
      {
        'b0o/SchemaStore.nvim',
        version = false,
      },
    },
    config = function()
      -- Require the keymaps and servers modules
      local keymaps = require 'plugins.lsp.keymaps'
      local servers = require 'plugins.lsp.servers'

      -- Set up capabilities for nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Set up the LSP servers
      servers.setup(capabilities)

      -- Create an autocommand group for LSP attachment
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          -- Get the LSP client
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- Attach keymaps
          keymaps.on_attach(client, event.buf)
        end,
      })

      -- Ensure Mason installs tools automatically
      require('mason').setup()

      -- Ensure servers are installed
      local ensure_installed = vim.tbl_keys(servers.list)
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'rust-analyzer',
        'clangd',
        'pyright',
        'lua-language-server',
        'gopls',
        'html-lsp',
        'css-lsp',
        'json-lsp',
        'yaml-language-server',
        'bash-language-server',
        'dockerfile-language-server',
        'marksman',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers.list[server_name] or {}
            -- This handles overriding only values explicitly passed
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  require 'plugins.lsp.format',
  require 'plugins.lsp.completion',
}
