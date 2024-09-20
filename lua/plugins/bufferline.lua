return {
  {
    'akinsho/bufferline.nvim',
    dependencies = 'nvim-tree/nvim-web-devicons', -- For file icons
    config = function()
      require('bufferline').setup {}
    end,
  },
  'moll/vim-bbye', -- Buffer deletion
}
