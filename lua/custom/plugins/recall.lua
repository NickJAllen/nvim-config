return {
  {
    'fnune/recall.nvim',
    config = function()
      local recall = require 'recall'

      recall.setup {
        sign = '',
        sign_highlight = '@comment.note',

        telescope = {
          autoload = true,
          mappings = {
            unmark_selected_entry = {
              normal = 'dd',
              insert = '<M-d>',
            },
          },
        },

        wshada = vim.fn.has 'nvim-0.10' == 0,
      }

      vim.keymap.set('n', '<leader>mm', recall.toggle, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>mn', recall.goto_next, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>mp', recall.goto_prev, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>mc', recall.clear, { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>ml', ':Telescope recall<CR>', { noremap = true, silent = true })
    end,
  },
}
