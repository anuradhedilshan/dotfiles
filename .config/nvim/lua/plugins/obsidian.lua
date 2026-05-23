return {
  'obsidian-nvim/obsidian.nvim',
  lazy = true,
  dependencies = {
    'nvim-telescope/telescope.nvim',
    'folke/snacks.nvim', -- optional
  },
  cmd = {
    'Obsidian',
  },

  keys = {
    { '<leader>nd', '<cmd>Obsidian dailies<CR>', desc = 'Obsidian daily note' },
    { '<leader>nt', '<cmd>Obsidian today<CR>', desc = 'Obsidian today note' },
    { '<leader>nd', '<cmd>Obsidian new_from_template <CR>', desc = 'Create from template' },
  },

  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false, -- this will be removed in 4.0.0

    workspaces = {
      {
        name = 'Notes',
        path = '~/Documents/Knowledge_Base',
        -- see below for full list of options 👇
      },
    },
    templates = {
      folder = '📒 Templates',
    },

    daily_notes = {
      template = 'daily-note.md',
      default_tags = { 'daily' },
      folder = '🚀 Notes/Daily Notes',
    },
  },
  -- config = function()
  --   require('obsidian').setup()
  -- end,
}
