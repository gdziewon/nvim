-- Highlight when yanking (copying) text
auto('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Automatically remove trailing whitespaces on save
auto('BufWritePre', {
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- Autocommand to save the colorscheme whenever it changes
auto('ColorScheme', {
  callback = function()
    local colorscheme = vim.g.colors_name
    local path = vim.fn.stdpath 'config' .. '/.colorscheme'
    local file = io.open(path, 'w')
    if file then
      file:write(colorscheme)
      file:close()
    end
  end,
})

-- Load saved colorscheme
auto('VimEnter', {
  callback = function()
    local path = vim.fn.stdpath 'config' .. '/.colorscheme'
    local file = io.open(path, 'r')
    if file then
      local colorscheme = file:read('*all'):gsub('%s+', '')
      file:close()
      if colorscheme and #colorscheme > 0 then
        pcall(vim.cmd.colorscheme, colorscheme)
      end
    end
  end,
})

-- Define a table with settings for each file type
local filetype_settings = {
  c = { tabstop = 2, shiftwidth = 2 },
  cpp = { tabstop = 2, shiftwidth = 2 },
  python = { tabstop = 4, shiftwidth = 4 },
}

-- Create a single autocmd that adjusts settings based on file type
auto('FileType', {
  pattern = '*',
  callback = function()
    local ft = vim.bo.filetype
    local settings = filetype_settings[ft]
    if settings then
      vim.opt_local.tabstop = settings.tabstop
      vim.opt_local.shiftwidth = settings.shiftwidth
      vim.opt_local.expandtab = true
    end
  end,
})
