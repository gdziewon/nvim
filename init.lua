_G.map = vim.keymap.set
_G.auto = vim.api.nvim_create_autocmd

require 'core.settings'
require 'core.keymaps'
require 'core.autocmds'
require 'plugins'
