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
          vim.cmd 'silent! edit!'
          print('Reloaded unmodified buffer ' .. name)
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

function M.open_messages()
  local buf = vim.api.nvim_create_buf(false, true)
  local output = vim.fn.execute 'messages'
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(output, '\n'))
  vim.api.nvim_set_current_buf(buf)
end

function M.delete_buffer_and_file()
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)

  -- Delete the file if it exists
  if filepath ~= '' and vim.loop.fs_stat(filepath) then
    os.remove(filepath)
  end

  -- Delete the buffer
  vim.api.nvim_buf_delete(bufnr, { force = true })
end

function M.open_directory_in_oil()
  local picker = require 'snacks.picker'

  local find_command = {
    'fd',
    '--type',
    'd',
    '--color',
    'never',
  }

  vim.fn.jobstart(find_command, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        local filtered = vim.tbl_filter(function(el)
          return el ~= ''
        end, data)

        local items = {}
        for _, v in ipairs(filtered) do
          table.insert(items, { text = v })
        end

        ---@module 'snacks'
        picker.pick {
          source = 'directories',
          items = items,
          layout = { preset = 'select' },
          format = 'text',
          confirm = function(picker, item)
            picker:close()
            vim.cmd('Oil ' .. item.text)
          end,
        }
      end
    end,
  })
end

return M
