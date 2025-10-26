local nick = require 'nick'

-- Used to schedule a snapshot if any files are written
local needs_to_make_snapshot_at_end_of_event = false

-- Refresh the state of unmodified buffers when focus is gained
vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    nick.utils.reload_unmodified_buffers()
  end,
})

-- Save all files after a refactoring completes
vim.api.nvim_create_autocmd('LspRequest', {
  callback = function(args)
    local request = args.data.request
    local request_method = request.method

    if request.type == 'complete' then
      -- do something with finished requests. this pending
      -- request entry is about to be removed since it is complete
      --

      local is_refacting = (request_method == 'textDocument/rename' or request_method == 'textDocument/codeAction')

      -- print('Finished LSP request ' .. request_method)

      if is_refacting then
        print 'Finished LSP refactoring'
        vim.schedule(nick.utils.save_all)
      end
    end
  end,
})

-- Make a snapshot in jj after any files are written to disk
vim.api.nvim_create_autocmd('BufWritePost', {
  callback = function(args)
    local buf = args.buf

    if vim.bo[buf].buftype ~= '' then
      return -- skip virtual/scratch/terminal buffers
    end

    if not needs_to_make_snapshot_at_end_of_event then
      needs_to_make_snapshot_at_end_of_event = true

      vim.defer_fn(function()
        needs_to_make_snapshot_at_end_of_event = false
        nick.utils.jj_snapshot()
      end, 0)
    end
  end,
})
