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

return M
