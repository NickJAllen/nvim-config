local M = {}

function M.save_all()
  vim.print 'Saving all files'
  vim.cmd 'wall'
end

function M.jj_snapshot()
  vim.print 'Making snapshot using Jujutsu'
  vim.fn.system 'jj status'
end

function M.save_snapshot()
  vim.print 'Making snapshot'
  M.save_all()
  M.jj_snapshot()
end

function M.reload_unmodified_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local bo = vim.bo[buf] -- buffer-local options table
      local name = vim.api.nvim_buf_get_name(buf)

      -- only reload real files that are modifiable and not modified
      if name ~= '' and vim.fn.filereadable(name) == 1 and bo.modifiable and not bo.modified then
        -- run checktime in that buffer's context to pick up external changes
        vim.api.nvim_buf_call(buf, function()
          print('Reloading unmodified buffer ' .. name)
          vim.cmd 'silent! checktime'
        end)
      end
    end
  end
end

return M
