return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
  config = function(_, opts)
    local gitsigns = require('gitsigns')
    gitsigns.setup(opts)
    
    -- Setup keymaps
    require('config.keymaps').setup_gitsigns_keymaps(gitsigns)
  end,
}
