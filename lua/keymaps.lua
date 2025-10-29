-- Save in insert mode with Ctrl-S
vim.keymap.set('i', '<C-s>', '<Esc>:write<CR>l')

-- Save in normal mode with Ctrl-S
vim.keymap.set('n', '<C-s>', ':write<CR>')

-- Save all with Ctrl-Shift-S
vim.keymap.set('n', '<C-S-S>', ':wall<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

local nick = require 'nick'

vim.keymap.set('n', '<leader>bb', ':buffer #<CR>', { desc = 'Back To Previous Buffer' })
vim.keymap.set('n', '<leader>bq', ':bdelete<CR>', { desc = 'Close Buffer' })
vim.keymap.set('n', '<leader>bd', nick.utils.delete_buffer_and_file, { desc = 'Delete Buffer and File' })
vim.keymap.set('n', '<leader>bo', nick.utils.close_other_unmodified_buffers, { desc = 'Close Other Unmodified Buffers' })
vim.keymap.set('n', '<leader>bm', nick.utils.open_messages, { desc = 'Open Messages' })
vim.keymap.set('n', '<leader>br', nick.utils.reload_unmodified_buffers, { desc = 'Reload Unmodified Buffers' })

vim.keymap.set('n', '<leader>s.', nick.utils.open_directory_in_oil, { desc = 'Open directory in Oil' }) -- vim: ts=2 sts=2 sw=2 et
