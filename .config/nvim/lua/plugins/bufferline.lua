return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    require('bufferline').setup {
      options = {
        numbers = 'ordinal',
        diagnostics = 'nvim_lsp',
        show_buffer_close_icons = true,
        show_close_icon = true,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            highlight = 'Directory',
            text_align = 'left',
          },
        },
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match 'error' and ' ' or ' '
          return ' ' .. icon .. count
        end,
      },
    }

    -- Dynamic buffer navigation: Alt+1-9
    for i = 1, 9 do
      vim.keymap.set('n', '<M-' .. i .. '>', '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>', { desc = 'Go to buffer ' .. i })
    end

    -- Super+bd for buffer delete
    vim.keymap.set('n', '<M-d>', '<Cmd>bdelete<CR>', { desc = 'Delete current buffer' })

    -- Additional buffer navigation
    vim.keymap.set('n', '<M-p>', '<Cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    vim.keymap.set('n', '<M-n>', '<Cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
  end,
}

