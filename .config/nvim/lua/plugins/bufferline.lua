return {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons',
config = function()
  require("bufferline").setup{
    options = {
      diagnostics = "nvim_lsp",
      show_buffer_close_icons = false,
      show_close_icon = false,
      offsets = {
        {
          filetype = "neo-tree",
          text = "File Explorer",
          highlight = "Directory",
          text_align = "left"
        }
      },
    }
  }
  
  -- Super fast buffer navigation: Super+1,2,3,4
  vim.keymap.set('n', '<M-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', { desc = 'Go to buffer 1' })
  vim.keymap.set('n', '<M-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', { desc = 'Go to buffer 2' })
  vim.keymap.set('n', '<M-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', { desc = 'Go to buffer 3' })
  vim.keymap.set('n', '<M-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', { desc = 'Go to buffer 4' })
  
  -- Super+bd for buffer delete
  vim.keymap.set('n', '<M-d>', '<Cmd>bdelete<CR>', { desc = 'Delete current buffer' })
  
  -- Additional buffer navigation
  vim.keymap.set('n', '<M-h>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
  vim.keymap.set('n', '<M-l>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
end 
}