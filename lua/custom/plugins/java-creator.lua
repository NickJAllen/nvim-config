return {
  {
    'NickJAllen/java-creator-nvim',
    dev = true,
    config = function()
      require('java-creator-nvim').setup {
        options = {
          java_version = 17,
          auto_open = true,
          use_notify = true,
          custom_src_path = 'backend/src/main/java',
          src_patterns = { 'src/main/java', 'src/test/java', 'src' },
          project_markers = { 'pom.xml', 'build.gradle', 'settings.gradle', '.project', 'backend' },
          package_selection_style = 'hybrid',
          notification_timeout = 3000,
        },
        keymaps = {
          java_new = '<leader>jn',
          java_class = '<leader>jc',
          java_interface = '<leader>ji',
          java_enum = '<leader>je',
          java_record = '<leader>jr',
        },
        default_imports = {
          record = { 'java.util.*' }, -- Import di default per i record
        },
      }

      vim.keymap.set('i', '<C-space>', 'pumvisible() ? "\\<C-n>" : "\\<C-x>\\<C-u>"', {
        expr = true,
        desc = '',
      })
    end,
    ft = 'java',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-telescope/telescope.nvim', optional = true },
      { 'rcarriga/nvim-notify', optional = true },
    },
  },
}
