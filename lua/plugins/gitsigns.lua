return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function gmap(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          map(mode, l, r, opts)
        end

        -- Navigation
        gmap('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        gmap('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        gmap('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })
        gmap('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })
        -- normal mode
        gmap('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        gmap('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        gmap('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        gmap('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        gmap('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        gmap('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        gmap('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        gmap('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        gmap('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
        -- Toggles
        gmap('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        gmap('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
