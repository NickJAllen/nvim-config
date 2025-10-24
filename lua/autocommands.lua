local nick = require 'nick'

vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    nick.utils.reload_unmodified_buffers()
  end,
})
