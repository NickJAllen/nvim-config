local M = {}

local jj_snapshot_timer = vim.uv.new_timer()

local function make_jj_snapshot()
  if jj_snapshot_timer:is_active() then
    jj_snapshot_timer:stop()
  end

  vim.print 'Making snapshot using Jujutsu'
  vim.fn.system 'jj status'
end

-- Saves all files
function M.save_all()
  vim.print 'Saving all files'
  vim.cmd 'wall'
  make_jj_snapshot()
end

function M.jj_snapshot()
  if jj_snapshot_timer:is_active() then
    jj_snapshot_timer:stop()
  end

  jj_snapshot_timer:start(100, 0, vim.schedule_wrap(make_jj_snapshot))
end

-- Called before we are about to perform an LSP refactoring
function M.before_refactoring()
  print 'About to perform refactoring'
  M.save_all()
end

-- Called after an LSP refactoring has completed
function M.after_refactoring_complete()
  print 'Refactoring complete'
  M.save_all()
  M.reload_unmodified_buffers()
end

-- Reloads any files from disk that haven't been modified in neovim
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

-- Closes other buffers than the current one that are normal files and not modified
function M.close_other_unmodified_buffers()
  local current = vim.api.nvim_get_current_buf()

  if vim.bo[current].buftype ~= '' then
    return
  end

  local bufs = vim.api.nvim_list_bufs()

  for _, buf in ipairs(bufs) do
    if buf ~= current then
      local modified = vim.bo[buf].modified
      local buftype = vim.bo[buf].buftype

      -- only close normal, unmodified buffers
      if not modified and buftype == '' then
        vim.api.nvim_buf_delete(buf, {})
      end
    end
  end
end

return M
