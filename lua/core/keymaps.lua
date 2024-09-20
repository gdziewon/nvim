-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use t to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Tmux keymaps
map('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { desc = 'Move focus to the upper window' })
map('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { desc = 'Move focus to the previous window' })

-- Indent lines in visual mode with TAB
map('v', '<Tab>', '>gv', { desc = 'Indent selected lines' })

-- Unindent lines in visual mode with SHIFT+TAB
map('v', '<S-Tab>', '<gv', { desc = 'Unindent selected lines' })

-- Key mappings for buffer navigation using vim.keymap.set
map('n', '<S-l>', ':BufferLineCycleNext<CR>', { desc = 'Go to next buffer' })
map('n', '<S-h>', ':BufferLineCyclePrev<CR>', { desc = 'Go to previous buffer' })
map('n', '<leader>bc', ':BufferLinePickClose<CR>', { desc = 'Close selected buffer' })
map('n', '<leader>bp', ':BufferLinePick<CR>', { desc = 'Pick buffer to focus' })
map('n', '<leader>bd', ':Bdelete<CR>', { desc = 'Delete current buffer' })
