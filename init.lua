-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.g.neovide_input_macos_option_key_is_meta = 'only_left'

vim.g.snacks_animate = true
vim.g.snacks_indent = true

-- [[ Setting options ]]
require 'options'

-- [[ Basic Keymaps ]]
require 'keymaps'

require 'autocommands'

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

-- vim.cmd 'colorscheme tokyonight-night'
vim.cmd 'colorscheme kanagawa'

vim.lsp.enable 'jdtls'
vim.lsp.enable 'clangd'
