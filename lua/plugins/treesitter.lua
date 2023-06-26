return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require 'nvim-treesitter.configs'.setup {
        -- Parser names
        ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'cpp', 'typescript',
          'javascript', 'tsx', 'markdown', 'comment', 'go', 'java'},
        -- Install parsers synchronously
        sync_install = false,

        auto_install = false,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        autiotag = {
          enable = true,
        },
      }
    end,
  }
}
