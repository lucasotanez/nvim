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
          'javascript', 'tsx', 'markdown', 'markdown_inline', 'latex', 'comment', 'go', 'java', 'css'},
        -- Install parsers synchronously
        sync_install = false,

        auto_install = false,

        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },

        autotag = {
          enable = true,
        },
      }
    end,
  }
}
