return {
  {
    'folke/tokyonight.nvim'
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup {
        flavour = 'macchiato'
      }
      require('catppuccin').load()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    config = function()
      -- statusline that shows current and total line number 
      local function line_total()
        local curs = vim.api.nvim_win_get_cursor(0)
        return curs[1] ..
          '/' ..
          vim.api.nvim_buf_line_count(vim.fn.winbufnr(0)) .. ' ' .. curs[2]
      end

      require('lualine').setup {
                sections = {
          lualine_z = { line_total },
        },
        options = {
          disabled_filetypes = {
            'alpha',
          },
          theme = 'powerline',
        },
      }
    end,
  }
}
