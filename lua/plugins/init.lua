local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim' -- Install lazy.nvim
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'christoomey/vim-tmux-navigator',
    lazy = false,
    config = function()
      -- Optional: custom configuration for the plugin can go here
    end,
  },
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },
  require 'plugins.which-key',
  require 'plugins.telescope',
  require 'plugins.lsp',
  require 'plugins.themes',
  require 'plugins.mini',
  require 'plugins.treesitter',
  require 'plugins.gitsigns',
  require 'plugins.autopairs',
  --require 'plugins.debug', -- not finished
  require 'plugins.neo-tree',
  require 'plugins.bufferline',
  -- require 'plugins.format',
  -- require 'plugins.completion',
  -- require 'kickstart.plugins.lint',
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
