local nick = require 'nick'

vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    nick.utils.reload_unmodified_buffers()
  end,
})

vim.api.nvim_create_autocmd('LspRequest', {
  callback = function(args)
    local bufnr = args.buf
    local client_id = args.data.client_id
    local request_id = args.data.request_id
    local request = args.data.request
    local request_method = request.method

    if request.type == 'complete' then
      -- do something with finished requests. this pending
      -- request entry is about to be removed since it is complete
      --

      local is_refacting = (request_method == 'textDocument/rename' or request_method == 'textDocument/codeAction')

      print('Finished LSP request ' .. request_method)

      if is_refacting then
        print 'Finished LSP refactoring'
        vim.schedule(nick.utils.save_snapshot)
      end
    end
  end,
})
