-- lua/plugins/themes.lua
return {
  -- Catppuccin Theme
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- High priority to load this theme first
    config = function()
      require('catppuccin').setup {
        flavor = 'macchiato',
        integrations = {
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
            },
          },
          cmp = true,
          gitsigns = true,
          telescope = true,
          nvimtree = true,
          which_key = true,
        },
      }
    end,
  },

  -- Tokyo Night Theme
  {
    'folke/tokyonight.nvim',
    priority = 1000, -- High priority to load this theme first
    config = function()
      vim.g.tokyonight_style = 'night'
    end,
  },

  -- Gruvbox Theme
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000, -- High priority to load this theme first
    config = function()
      require('gruvbox').setup {
        contrast = 'hard',
        palette_overrides = {
          dark0_hard = '#1d2021',
          bright_red = '#fb4934',
        },
      }
    end,
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },
}
