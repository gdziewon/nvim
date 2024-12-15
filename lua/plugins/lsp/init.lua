return {
  {
    -- LazyDev configures Lua LSP for your Neovim config, runtime, and plugins
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
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
      -- Ensure Mason installs tools automatically
      require('mason').setup()
      require('mason-lspconfig').setup()

      -- Load keymaps
      local keymaps = require 'plugins.lsp.keymaps'

      -- Load LSP servers list after Mason setup
      local servers = require 'plugins.lsp.servers'

      -- Set up capabilities for nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      -- Initialize LSP servers
      servers.setup(capabilities)

      -- Create autocommand for attaching LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          keymaps.on_attach(client, event.buf)
        end,
      })

      -- Ensure specific servers are installed
      local ensure_installed = vim.tbl_keys(servers.list)
      vim.list_extend(ensure_installed, {
        'stylua',
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

      -- Set up Mason LSP config handlers after loading servers
      require('mason-lspconfig').setup {
        handlers = {
          function(server_name)
            local server = servers.list[server_name] or {}
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
