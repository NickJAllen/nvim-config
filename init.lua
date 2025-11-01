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

-- [[ Install `lazy.nvim` plugin manager ]]
require 'lazy-bootstrap'

-- [[ Configure and install plugins ]]
require 'lazy-plugins'

require 'autocommands'

-- [[ Basic Keymaps ]]
require 'keymaps'

local colorscheme = 'catppuccin-mocha'
-- local colorscheme = 'tokyonight-night'
-- local colorscheme = 'kanagawa'
vim.cmd('colorscheme ' .. colorscheme)

vim.lsp.config('jdtls', {
  settings = {
    java = {
      -- Custom eclipse.jdt.ls options go here
      -- https://github.com/eclipse-jdtls/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request

      saveActions = {
        organizeImports = false,
        cleanup = true,
      },
      cleanup = {
        actionsOnSave = { 'addOverride', 'addFinalModifier', 'instanceofPatternMatch', 'organizeImports', 'lambdaExpression', 'switchExpression' },
      },
    },
  },
})

vim.lsp.enable 'jdtls'
vim.lsp.enable 'clangd'
