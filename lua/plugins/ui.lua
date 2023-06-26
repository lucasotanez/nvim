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
  },

  {
    'nvim-tree/nvim-web-devicons',
    lazy = true,
  },
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      -- Toggle filetree
      { '<leader>t', '<Cmd>NvimTreeToggle<CR>' },
    },
    cmd = { 'NvimTreeFindFileToggle', 'NvimTreeToggle' },
    config = function()
      local HEIGHT_RATIO = 0.75
      local WIDTH_RATIO = 0.5
      -- turning off float will show a VSCode-style file explorer on left
      local FLOAT_ENABLED = true 

      -- custom mappings
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')
        
        local function opts(desc)
          return {
            desc = 'nvim-tree: ' .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        -- BEGIN CUSTOM MAPPINGS

        vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Open'))
        vim.keymap.set('n', '<Esc>', api.tree.close, opts('Close'))

        -- END CUSTOM MAPPINGS

        local function tab_with_close()
          if not FLOAT_ENABLED then vim.api.nvim_command('wincmd h') end
          api.node.open.tab()
        end
      end

      require('nvim-tree').setup {
        on_attach = on_attach,
        hijack_cursor = true,
        update_focused_file = {
          enable = true,
        },
        view = {
          float = {
            enable = FLOAT_ENABLED,
            open_win_config = function()
              -- center the window
              local screen_w = vim.opt.columns:get()
              local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
              local window_w = screen_w * WIDTH_RATIO
              local window_h = screen_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (screen_w - window_w) / 2
              local center_y = ((vim.opt.lines:get() - window_h) / 2) -
                  vim.opt.cmdheight:get()

              return {
                relative = 'editor',
                border = 'rounded',
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end,
          },
        },
        renderer = {
          -- add '/' at the end of a folder
          add_trailing = false,
          icons = {
            show = {
              --remove annoying icons
              modified = true,
              git = false,
            },
          },
        },
        tab = {
          sync = {
            open = true,
            close = true,
          },
        },
      }
    end,
  },
}
